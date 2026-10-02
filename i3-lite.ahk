#Requires AutoHotkey v2.0

; Mod key = Win
;#j::WinActivateBottom("A")
;#k::WinActivate("A")
;#h::Send("^!{Left}")
;#l::Send("^!{Right}")

; Launch terminal
#Enter::Run("cmd.exe", EnvGet("USERPROFILE"))

; Launch app
#d::Run("C:\Program Files (x86)\Everything\Everything.exe")
#b::Run("C:\Program Files\Mozilla Firefox\firefox.exe")
#w::Run("C:\Program Files\LibreOffice\program\swriter.exe")
#c::Run("C:\Program Files\LibreOffice\program\scalc.exe")
#t::Run("C:\Windows\system32\notepad.exe")
#k::Run("C:\Program Files\Kdenlive\bin\kdenlive.exe")

; Close window
#q::Send "!{F4}"

; Minimize
#+m::WinMinimize("A")

; Maximize / restore
#f::WinMaximize("A")

; Autocomplete stuff
:*:certidig::https://ridigital.org.br/CertidaoDigital/Default.aspx
:*:boatard::Boa tarde, amigo!

; Scan stuff
#+s:: {
    ib := InputBox(,"Scanner", "w200 h70")
    if ib.Result = "OK" && ib.Value != "" {
        filename := ib.Value
        output := "\\mesa-2\digitalizados\" . filename . ".pdf"

        Run('"NAPS2.Console.exe" -o "' . output . '"')
    }
}

; Scan and append to most recent PDF
#^s:: {
    folder := "\\mesa-2\digitalizados"
    latestFile := ""
    latestTime := 0

    Loop Files, folder "\*.pdf", "F" {
        fileTime := FileGetTime(A_LoopFileFullPath, "M")

        if (fileTime > latestTime) {
            latestTime := fileTime
            latestFile := A_LoopFileFullPath
        }
    }

    if (latestFile = "") {
        MsgBox("No PDF files found in:`n" folder)
        return
    }

    naps2 := "NAPS2.Console.exe"

    Run(
        '"' naps2 '" -i "' latestFile '" -o "' latestFile '" -f'
    )
}

; Convert pdf easy
^#p::
{
    files := Explorer_GetSelected()

    if !files.Length
        return

    SplitPath(files[1], , &outputDir)

    command := 'soffice --headless --convert-to pdf --outdir "' outputDir '"'

    for file in files
        command .= ' "' file '"'

    Run(command)
}

Explorer_GetSelected()
{
    selected := []

    shell := ComObject("Shell.Application")

    for window in shell.Windows
    {
        try
        {
            if window.HWND != WinActive("A")
                continue

            items := window.Document.SelectedItems

            for item in items
                selected.Push(item.Path)

            break
        }
    }

    return selected
}

; Reload this script
#+r::Reload()

; Exit this script
#+q::ExitApp()
