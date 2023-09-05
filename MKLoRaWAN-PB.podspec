#
# Be sure to run `pod lib lint MKLoRaWAN-PB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKLoRaWAN-PB'
  s.version          = '1.0.3'
  s.summary          = 'A short description of MKLoRaWAN-PB.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MKLoRa/MKLoRa-LW004-PB-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MKLoRa/MKLoRa-LW004-PB-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKLoRaWAN-PB' => ['MKLoRaWAN-PB/Assets/*.png']
  }
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/CTMediator/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/Target/**'
    
    ss.dependency 'MKLoRaWAN-PB/Functions'
  end
  
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/ConnectModule/**'
    
    ss.dependency 'MKLoRaWAN-PB/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'DatabaseManager' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/DatabaseManager/**'
    
    ss.dependency 'FMDB'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'Expand' do |ss|
    
    ss.subspec 'TextButtonCell' do |sss|
      sss.source_files = 'MKLoRaWAN-PB/Classes/Expand/TextButtonCell/**'
    end
    
    ss.subspec 'FilterCell' do |sss|
      sss.subspec 'FilterBeaconCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Expand/FilterCell/FilterBeaconCell/**'
      end
      
      sss.subspec 'FilterByRawDataCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Expand/FilterCell/FilterByRawDataCell/**'
      end
      
      sss.subspec 'FilterEditSectionHeaderView' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Expand/FilterCell/FilterEditSectionHeaderView/**'
      end
      
      sss.subspec 'FilterNormalTextFieldCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Expand/FilterCell/FilterNormalTextFieldCell/**'
      end
      
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AlarmFunctionPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AlarmFunctionPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/AlarmFunctionPage/Model'
        ssss.dependency 'MKLoRaWAN-PB/Functions/AlarmFunctionPage/View'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/AlertSettingsPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/SOSSettingsPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AlarmFunctionPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AlarmFunctionPage/View/**'
      end
    end
    
    ss.subspec 'AlertSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AlertSettingsPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/AlertSettingsPage/Model'
      
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AlertSettingsPage/Model/**'
      end
    end
    
    ss.subspec 'AuxiliaryPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AuxiliaryPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/DownlinkPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/ManDownPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/AlarmFunctionPage/Controller'
      end
    end
    
    ss.subspec 'AxisSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AxisSettingsPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/AxisSettingsPage/Model'
      
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/AxisSettingsPage/Model/**'
      end
    end
    
    ss.subspec 'BleFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/BleFixPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/BleFixPage/Model'
        ssss.dependency 'MKLoRaWAN-PB/Functions/BleFixPage/View'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/BleFixPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/BleFixPage/View/**'
      end
    end
    
    ss.subspec 'BleSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/BleSettingPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/BleSettingPage/Model'
        ssss.dependency 'MKLoRaWAN-PB/Functions/BleSettingPage/View'
      
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/BleSettingPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/BleSettingPage/View/**'
      end
    end
    
    ss.subspec 'DebuggerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DebuggerPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/DebuggerPage/View'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DebuggerPage/View/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DeviceInfoPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/DeviceInfoPage/Model'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/DebuggerPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/UpdatePage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/SelftestPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end
    
    ss.subspec 'DeviceModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DeviceModePage/Controller/**'
              
        ssss.dependency 'MKLoRaWAN-PB/Functions/TimingModePage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/PeriodicModePage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/MotionModePage/Controller'
      end
    end
    
    ss.subspec 'DeviceSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DeviceSettingPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/DeviceSettingPage/Model'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/DeviceInfoPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/ONOFFSettingsPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DeviceSettingPage/Model/**'
      end
    end
    
    ss.subspec 'DownlinkPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DownlinkPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/DownlinkPage/Model'
        
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/DownlinkPage/Model/**'
      end
    end
    
    ss.subspec 'FilterPages' do |sss|
      
      sss.subspec 'FilterByAdvNamePage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByAdvNamePage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByAdvNamePage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByAdvNamePage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBeaconPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByBeaconPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByBeaconPage/Header'
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByBeaconPage/Model'
          
        end
        
        ssss.subspec 'Header' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByBeaconPage/Header/**'
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByBeaconPage/Model/**'
          
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByBeaconPage/Header'
        end
      end
      
      sss.subspec 'FilterByMacPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByMacPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByMacPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByMacPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByOtherPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByOtherPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByOtherPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByOtherPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByRawDataPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByRawDataPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByRawDataPage/Model'
          
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByBeaconPage/Controller'
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByUIDPage/Controller'
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByURLPage/Controller'
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByTLMPage/Controller'
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByOtherPage/Controller'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByRawDataPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByTLMPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByTLMPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByTLMPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByTLMPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByUIDPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByUIDPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByUIDPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByUIDPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByURLPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByURLPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-PB/Functions/FilterPages/FilterByURLPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/FilterPages/FilterByURLPage/Model/**'
        end
      end
      
    end
    
    ss.subspec 'GeneralPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/GeneralPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/GeneralPage/Model'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/DeviceModePage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/AuxiliaryPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/AxisSettingsPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/BleSettingPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/GeneralPage/Model/**'
      end
    end
    
    ss.subspec 'GpsFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/GpsFixPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/GpsFixPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/GpsFixPage/Model/**'
      end
    end
    
    ss.subspec 'LoRaApplicationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/LoRaApplicationPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/LoRaApplicationPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/LoRaApplicationPage/Model/**'
      end
    end
    
    ss.subspec 'LoRaPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/LoRaPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/LoRaPage/Model'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/LoRaApplicationPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/LoRaSettingPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/LoRaPage/Model/**'
      end
    end
    
    ss.subspec 'LoRaSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/LoRaSettingPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/LoRaSettingPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/LoRaSettingPage/Model/**'
      end
    end
    
    ss.subspec 'ManDownPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ManDownPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/ManDownPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ManDownPage/Model/**'
      end
    end
    
    ss.subspec 'MotionModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/MotionModePage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/MotionModePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/MotionModePage/Model/**'
      end
    end
    
    ss.subspec 'ONOFFSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ONOFFSettingsPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/ONOFFSettingsPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ONOFFSettingsPage/Model/**'
      end
    end
    
    ss.subspec 'PeriodicModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/PeriodicModePage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/PeriodicModePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/PeriodicModePage/Model/**'
      end
    end
    
    ss.subspec 'PositionPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/PositionPage/Controller/**'
              
        ssss.dependency 'MKLoRaWAN-PB/Functions/BleFixPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/GpsFixPage/Controller'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ScanPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/ScanPage/Model'
        ssss.dependency 'MKLoRaWAN-PB/Functions/ScanPage/View'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/TabBarPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ScanPage/View/**'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/ScanPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/ScanPage/Model/**'
      end
    end
    ss.subspec 'SelftestPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/SelftestPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/SelftestPage/Model'
        ssss.dependency 'MKLoRaWAN-PB/Functions/SelftestPage/View'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/SelftestPage/View/**'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/SelftestPage/Model/**'
      end
    end
    ss.subspec 'SOSSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/SOSSettingsPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/SOSSettingsPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/SOSSettingsPage/Model/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-PB/Functions/LoRaPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/PositionPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/GeneralPage/Controller'
        ssss.dependency 'MKLoRaWAN-PB/Functions/DeviceSettingPage/Controller'
      end
    end
    
    ss.subspec 'TimingModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/TimingModePage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/TimingModePage/Model'
        ssss.dependency 'MKLoRaWAN-PB/Functions/TimingModePage/View'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/TimingModePage/View/**'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/TimingModePage/Model/**'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/UpdatePage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-PB/Functions/UpdatePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-PB/Classes/Functions/UpdatePage/Model/**'
      end
    
      sss.dependency 'iOSDFULibrary'
    end
    
    ss.dependency 'MKLoRaWAN-PB/SDK'
    ss.dependency 'MKLoRaWAN-PB/CTMediator'
    ss.dependency 'MKLoRaWAN-PB/ConnectModule'
    ss.dependency 'MKLoRaWAN-PB/Expand'
    ss.dependency 'MKLoRaWAN-PB/DatabaseManager'
  
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    
  end
  
end
