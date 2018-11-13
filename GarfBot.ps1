#################
#               #
#    GARFBOT    #
#               #
#################

# Gets a random garfield comic and displays it in a separate window.
# There seems to be a garf comic for every day since 1978 so it should always work.

function Garf-Date
{
    # Returns date in "Garf Format(tm)".
    return (Get-Date).AddDays(-(New-TimeSpan '6/1/1978').Days * (Get-Random -Maximum 1.0)).ToString('yyyy/yyyy-MM-dd')
}

function Garf-Main
{
    # Black magic.
    $GarfDate = Garf-Date
    $GarfPath = "$ENV:Temp\garf.gif"
    $GarfURL = "https://d1ejxu6vysztl5.cloudfront.net/comics/garfield/$GarfDate.gif"
    Invoke-WebRequest -Uri $GarfURL -OutFile $GarfPath

    # Generate form and display image.
    $GarfImage = [System.Drawing.Image]::Fromfile($GarfPath)
    ($GarfForm = [Windows.Forms.Form]@{
            Text   = "GARFBOT!!!!!!!! $(($GarfDate).SubString(5))"
            Width  =  $GarfImage.Size.Width + 15
            Height =  $GarfImage.Size.Height + 40}

        ).Controls.Add(

            [Windows.Forms.PictureBox]@{
                Image = $GarfImage
                Size  = $GarfImage.Size})

    $GarfForm.ShowDialog()
    $GarfImage.Dispose()
}

Garf-Main