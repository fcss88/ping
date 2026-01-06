Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# ================= PATHS =================
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$hostsFile = Join-Path $scriptDir "hosts.txt"

if (-not (Test-Path $hostsFile)) {
    New-Item -Path $hostsFile -ItemType File -Force | Out-Null
}

# ================= FORM =================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Net Tester"
$form.Size = New-Object System.Drawing.Size(560,420)
$form.StartPosition = "CenterScreen"

# ================= INPUT =================
$cmbTarget = New-Object System.Windows.Forms.ComboBox
$cmbTarget.Location = New-Object System.Drawing.Point(20,20)
$cmbTarget.Width = 380
$cmbTarget.DropDownStyle = "DropDown"

Get-Content $hostsFile | ForEach-Object {
    if ($_ -match '.+:\d+') { $cmbTarget.Items.Add($_) }
}

$btnTest = New-Object System.Windows.Forms.Button
$btnTest.Text = "Test"
$btnTest.Location = New-Object System.Drawing.Point(420,18)
$btnTest.Width = 100

# ================= HISTORY =================
$lstHistory = New-Object System.Windows.Forms.ListBox
$lstHistory.Location = New-Object System.Drawing.Point(20,60)
$lstHistory.Size = New-Object System.Drawing.Size(500,280)

# ================= STATUS =================
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(20,350)
$lblStatus.Size = New-Object System.Drawing.Size(500,20)
$lblStatus.Text = "Ready"

# ================= LOGIC =================
function Run-Test {
    $cmbTarget.BackColor = "White"

    $inputValue = $cmbTarget.Text.Trim()

    if ($inputValue -notmatch '^(.+):(\d+)$') {
        $cmbTarget.BackColor = "MistyRose"
        $lblStatus.ForeColor = "Red"
        $lblStatus.Text = "Invalid format. Use host:port"
        return
    }

    $targetHost = $matches[1]
    $targetPort = [int]$matches[2]

    # Save to hosts.txt if new
    if (-not (Select-String -Path $hostsFile -SimpleMatch $inputValue -Quiet)) {
        Add-Content -Path $hostsFile -Value $inputValue
        $cmbTarget.Items.Add($inputValue)
    }

    $lblStatus.ForeColor = "Black"
    $lblStatus.Text = "Testing ${targetHost}:${targetPort}..."

    try {
        $ok = Test-NetConnection `
            -ComputerName $targetHost `
            -Port $targetPort `
            -InformationLevel Quiet `
            -WarningAction SilentlyContinue

        $time = Get-Date -Format "HH:mm:ss"

        if ($ok) {
            $lblStatus.ForeColor = "Green"
            $lblStatus.Text = "SUCCESS ${targetHost}:${targetPort}"
            $lstHistory.Items.Insert(0, "[$time] SUCCESS ${targetHost}:${targetPort}")
        }
        else {
            $lblStatus.ForeColor = "Red"
            $lblStatus.Text = "FAILED ${targetHost}:${targetPort}"
            $lstHistory.Items.Insert(0, "[$time] FAILED  ${targetHost}:${targetPort}")
        }
    }
    catch {
        $lblStatus.ForeColor = "Red"
        $lblStatus.Text = "ERROR: $($_.Exception.Message)"
    }
}

# ================= EVENTS =================
$btnTest.Add_Click({ Run-Test })

$cmbTarget.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        $_.SuppressKeyPress = $true
        Run-Test
    }
})

# ================= UI =================
$form.Controls.AddRange(@(
    $cmbTarget,
    $btnTest,
    $lstHistory,
    $lblStatus
))

$form.Add_Shown({ $form.Activate() })
[void][System.Windows.Forms.Application]::Run($form)
