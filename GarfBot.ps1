#################
#               #
#    GARFBOT    #
#               #
#################

# Gets a random garfield comic and displays it in a separate window.
# There seems to be a garf comic for every day since 1978 so it should always work.

# This program must be run as admin.

function Garf-Date
{
    # Sloppy code to get a date in "Garf Format(tm)". There's probably a better way to do this.
    [datetime]$Beginning = "06/01/1978"
    [datetime]$End = [datetime]::Now
    $RandomSeed = Get-Random -Minimum $Beginning.Ticks -Maximum $End.Ticks
    $GarfDate = Get-Date $RandomSeed
    $GarfYear = $GarfDate.Year
    $GarfMonth = $GarfDate.Month
    if ($GarfMonth.ToString().Length -eq 1){$GarfMonth = "0" + $GarfMonth}
    $GarfDay = $GarfDate.Day
    if ($GarfDay.ToString().Length -eq 1){$GarfDay = "0" + $GarfDay}
    return "$GarfYear/$GarfYear-$GarfMonth-$GarfDay"  
}

function Main
{
    # Black magic.
    $GarfURL = "https://d1ejxu6vysztl5.cloudfront.net/comics/garfield/" + (Garf-Date) + ".gif"
    $GarfImage = Invoke-WebRequest -Uri $GarfURL -OutFile "$env:HOMEDRIVE\garf.gif"

    # Generate form with Garf pic.
    [void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
    $FilePath = (Get-Item "$env:HOMEDRIVE\garf.gif")
    $Image = [System.Drawing.Image]::Fromfile($FilePath);
    [System.Windows.Forms.Application]::EnableVisualStyles();
    $Form = New-Object Windows.Forms.Form
    $Form.Text = "Image Viewer"
    $Form.Width = $Image.Size.Width + 15;
    $Form.Height =  $Image.Size.Height + 40;
    $PictureBox = New-Object Windows.Forms.PictureBox
    $PictureBox.Width =  $Image.Size.Width;
    $PictureBox.Height =  $Image.Size.Height;
    $PictureBox.Image = $Image;
    $Form.controls.add($PictureBox)
    $Form.Add_Shown( { $Form.Activate() } )
    $Form.ShowDialog()
    #$Form.Show()
}

Main