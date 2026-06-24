-- Decompiled from Lua 5.3 Bytecode
-- Mod Name: OneClickFavour (一键满好感度)

local CS = CS
local XiaWorld = CS.XiaWorld
local GameMain = CS.GameMain
local Wnd_JianghuTalk = CS.Wnd_JianghuTalk
local UIPackage = CS.UIPackage
local Language = CS.Language

local OneClickFavour = {}
local Inited = false

-- Proteksi Mod (Anti-Steal / Anti-Unpack Validation)
function OneClickFavour.CheckAuth()
    -- Mod melakukan pengecekan ke workshop resmi agar tidak diintegrasikan tanpa izin
    local modInstance = CS.ModsMgr.Instance:FindMod("一键满好感度")
    if not modInstance then
        local msgCN = "检测到本mod被未授权整合！\n请到工坊订阅正版mod！\n以免出现bug无人修复！"
        local msgEN = "Detected Unauthorized Usage!\nPlease download the Original Mod from workshop!"
        CS.Wnd_Message.Show(msgCN)
        return false
    end
    return true
end

-- Fungsi Utama ketika Tombol "Satu Klik Maksimal好感" Ditekan
function OneClickFavour.OnClick()
    local window = Wnd_JianghuTalk.Instance
    if not window then
        print("出错啦！\n交流窗口获取失败！")
        return
    end

    -- Mengambil data target NPC yang sedang diajak bicara
    local targetData = window.targetdata
    if not targetData then
        print("出错啦！\n交流对象获取失败！")
        return
    end

    -- Eksekusi memaksimalkan favor/好感度 lewat JianghuMgr
    local npcId = targetData.id
    CS.XiaWorld.JianghuMgr.Instance:AddKnowNpcData(npcId)
    
    -- Set nilai favor ke maksimal (100) dan kunci
    targetData.favour = 100
    targetData.hlock = true
    
    -- Perbarui UI Tampilan game
    window:UpdateFavour()
    window:UpdateBnt()
    
    print("操作成功！\n好感度已满！")
    CS.Wnd_Message.Show("Easy Job!\nFavour Maxed")
end

-- Fungsi Mengisi Tombol UI baru ke Jendela Interaksi Jianghu
function OneClickFavour.AddButton()
    local window = Wnd_JianghuTalk.Instance
    if not window or not window.contentPane then
        print("JianghuTalk提前初始化失败！")
        return
    end

    -- Menghindari duplikasi tombol jika sudah ada
    if window.contentPane:GetChild("FullFavour") then
        print("一键好感度按钮已存在！")
        return
    end

    -- Membuat objek tombol baru dari UI Package bawaan mod
    local btnUrl = "ui://0xrxw6g7hdhl18"
    local newBtn = UIPackage.CreateObjectFromURL(btnUrl):AsButton()
    newBtn.name = "FullFavour"
    newBtn.title = "一键满好感度" -- Text: 1-Click Max Favor
    newBtn.width = 100
    
    -- Mengatur posisi koordinat tombol di UI Window
    newBtn:SetXY(80, 20) 
    
    -- Binding fungsi klik ke fungsi penambah好感 yang tadi dibuat
    newBtn.onClick:Add(OneClickFavour.OnClick)
    
    -- Masukkan tombol baru ke dalam panel game
    window.contentPane:AddChild(newBtn)
end

-- Inisialisasi Event Listener saat Mod dimuat pertama kali
function OneClickFavour.OnInit()
    if Inited then return end
    
    -- Mendaftarkan mod agar memicu fungsi 'AddButton' saat jendela interaksi terbuka
    CS.GameMain.Instance:GetMod()._Event:RegisterEvent(
        CS.g_emEvent.WindowEvent, 
        function(e, thing, obj)
            if obj == "Wnd_JianghuTalk" then
                OneClickFavour.AddButton()
            end
        end
    )
    
    Inited = true
end

-- Menjalankan Proteksi dan Inisialisasi awal
if OneClickFavour.CheckAuth() then
    OneClickFavour.OnInit()
end

return OneClickFavour
