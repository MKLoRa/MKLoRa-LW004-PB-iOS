Pod::Spec.new do |s|
  s.name             = 'MKLoRaWAN-PB'
  s.version          = '1.0.7'
  s.summary          = 'A short description of MKLoRaWAN-PB.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/MKLoRa/MKLoRa-LW004-PB-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MKLoRa/MKLoRa-LW004-PB-iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '18.0'
  
  # ========== 资源文件 ==========
  s.resource_bundles = {
    'MKLoRaWAN-PB' => ['MKLoRaWAN-PB/Assets/*.png']
  }
  
  # ========== CTMediator 路由层 ==========
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/CTMediator/**/*.{h,m}'
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'CTMediator'
  end
  
  # ========== SDK 层 ==========
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/SDK/**/*.{h,m}'
    ss.dependency 'MKBaseBleModule'
  end
  
  # ========== Target 层 ==========
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/Target/**/*.{h,m}'
    ss.dependency 'MKLoRaWAN-PB/Functions'
  end
  
  # ========== 连接模块 ==========
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/ConnectModule/**/*.{h,m}'
    ss.dependency 'MKLoRaWAN-PB/SDK'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  # ========== 数据库层 ==========
  s.subspec 'DatabaseManager' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/DatabaseManager/**/*.{h,m}'
    ss.dependency 'FMDB'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  # ========== 扩展工具层 ==========
  s.subspec 'Expand' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/Expand/**/*.{h,m}'
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  # ========== 登录管理 ==========
  s.subspec 'LoginManager' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/LoginManager/**/*.{h,m}'
    ss.dependency 'MKIotCloudManager'
  end
  
  # ========== 完整功能层（包含所有页面）==========
  s.subspec 'Functions' do |ss|
    ss.source_files = 'MKLoRaWAN-PB/Classes/Functions/**/*.{h,m}'
    
    # 模块内依赖
    ss.dependency 'MKLoRaWAN-PB/SDK'
    ss.dependency 'MKLoRaWAN-PB/CTMediator'
    ss.dependency 'MKLoRaWAN-PB/ConnectModule'
    ss.dependency 'MKLoRaWAN-PB/Expand'
    ss.dependency 'MKLoRaWAN-PB/DatabaseManager'
    ss.dependency 'MKLoRaWAN-PB/LoginManager'
    
    # 公共依赖
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary', '4.13.0'
  end
  
end
