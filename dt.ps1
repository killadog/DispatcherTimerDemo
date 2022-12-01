Add-Type -Assembly PresentationFramework            
Add-Type -Assembly PresentationCore            

[xml]$XAML = Get-Content "$PSScriptRoot\dt.xaml"
$XAMLReader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($XAMLReader)
$XAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $Window.FindName($_.Name) }

$timer1 = new-object System.Windows.Threading.DispatcherTimer
$timer2 = new-object System.Windows.Threading.DispatcherTimer

$Global:counter1 | Out-Null
$Global:counter2 | Out-Null
$Global:StartDate1 | Out-Null
$Global:StartDate2 | Out-Null
$Global:Run_1 = $True
$Global:Run_2 = $True

#-------------Clock Begin-----------
$timer_clock = new-object System.Windows.Threading.DispatcherTimer
$timer_clock.Interval = [TimeSpan]"0:0:0.25"            
$timer_clock.Add_Tick({
      $Window.Resources["Value_clock"] = (Get-Date -UFormat '%Y/%m/%d-%H:%M:%S')
   })

$timer_clock.Start()            

if ($timer_clock.IsEnabled) {     
   $Log.AppendText("'timer_clock' start`n")
   $Log.ScrollToEnd()       
}
else {     
   $Log.AppendText("'timer_clock' didn't start`n")
   $Log.ScrollToEnd()            
}           
#-------------Clock End-----------

#-------------Left panel Begin----
$Button_1.Add_Click({
      if ($Global:Run_1) {
         
         $Global:Run_1 = $False
         $Button_1.Content = "Stop"

         $Global:counter1 = 1
   
         $timer1.Interval = [TimeSpan]"0:0:0.01"            
         $timer1.Add_Tick(
            {
               if ($timer1.IsEnabled) {
                  if ($Global:counter1 -lt $($TextBox_Numbers1.Text)) {
                     $Global:counter1++
                     $Window.Resources["Value_counter1"] = "[$($Global:counter1) / $($TextBox_Numbers1.Text)]"
                     $ProgressBar1.Value = $Global:counter1 * 100 / $($TextBox_Numbers1.Text)
                     $Window.Resources["Value_elapsed1"] = "[$('{0:N3}' -f ((New-TimeSpan –Start $Global:StartDate1 –End $(GET-DATE)).TotalSeconds)) s]"
                  }
                  else {
                     $timer1.Stop()
                     $Global:Run_1 = $True
                     $TextBox_Numbers1.IsEnabled = $true
                     $Button_1.Content = "Run"
                     $Log.AppendText("'timer1' stop $($Label_Time1.Content) $($Label_Counter1.Content)`n")
                     $Log.ScrollToEnd()      
                  }
               }
            })
         $timer1.Start()

         if ($timer1.IsEnabled) {
            $Global:StartDate1 = (GET-DATE)
            $TextBox_Numbers1.IsEnabled = $False
            $Log.AppendText("'timer1' start`n")
            $Log.ScrollToEnd()             
         }
         else {            
            $Log.AppendText("'timer1' didn't start`n")
            $Log.ScrollToEnd()      
         }           
      }
      else {
         $timer1.Stop()
         if (!$timer1.IsEnabled ) {
            $Global:Run_1 = $True
            $TextBox_Numbers1.IsEnabled = $true
            $Button_1.Content = "Run"
            $Log.AppendText("'timer1' stop $($Label_Time1.Content) $($Label_Counter1.Content)`n")
            $Log.ScrollToEnd()            
         }
      }  
   })
#-------------Left panel End-------

#-------------Right panel Begin----
$Button_2.Add_Click({
      if ($Global:Run_2) {
         
         $Global:Run_2 = $False
         $Button_2.Content = "Stop"

         $Global:counter2 = 1
   
         $timer2.Interval = [TimeSpan]"0:0:0.01"            
         $timer2.Add_Tick(
            {
               if ($timer2.IsEnabled) {
                  if ($Global:counter2 -lt $($TextBox_Numbers2.Text)) {
                     $Global:counter2++
                     $Window.Resources["Value_counter2"] = "[$($Global:counter2) / $($TextBox_Numbers2.Text)]"
                     $ProgressBar2.Value = $Global:counter2 * 100 / $($TextBox_Numbers2.Text)
                     $Window.Resources["Value_elapsed2"] = "[$('{0:N3}' -f ((New-TimeSpan –Start $Global:StartDate2 –End $(GET-DATE)).TotalSeconds)) s]"
                  }
                  else {
                     $timer2.Stop()
                     $Global:Run_2 = $True
                     $TextBox_Numbers2.IsEnabled = $true
                     $Button_2.Content = "Run"
                     $Log.AppendText("'timer2' stop $($Label_Time2.Content) $($Label_Counter2.Content)`n")
                     $Log.ScrollToEnd()      
                  }
               }
            })
         $timer2.Start()

         if ($timer2.IsEnabled) {
            $Global:StartDate2 = (GET-DATE)
            $TextBox_Numbers2.IsEnabled = $False
            $Log.AppendText("'timer2' start`n")
            $Log.ScrollToEnd()             
         }
         else {            
            $Log.AppendText("'timer2' didn't start`n")
            $Log.ScrollToEnd()      
         }           
      }
      else {
         $timer2.Stop()
         if (!$timer2.IsEnabled ) {
            $Global:Run_2 = $True
            $TextBox_Numbers2.IsEnabled = $true
            $Button_2.Content = "Run"
            $Log.AppendText("'timer2' stop $($Label_Time2.Content) $($Label_Counter2.Content)`n")
            $Log.ScrollToEnd()            
         }
      }  
   })
#-------------Left panel End------

$Window.ShowDialog() | Out-Null
$timer1.Stop()
$timer2.Stop()
$timer_clock.Stop()
