// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MKLoRaWAN-PB",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "MKLoRaWAN-PBSDK", targets: ["MKLoRaWAN-PBSDK"]),
        .library(name: "MKLoRaWAN-PB", targets: ["MKLoRaWAN-PB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKBaseModuleLibrary.git", from: "2.2.19"),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKBaseBleModule.git", from: "1.1.6"),
        .package(url: "https://github.com/ccgus/fmdb.git", from: "2.7.0"),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKCustomUIModule.git", from: "2.1.17"),
        .package(url: "git@120.27.8.241:MokoTest/MKIoTDM_iOS.git", from: "0.1.9"),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKFilterPagesModule.git", from: "0.0.19"),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/LoRaCommonModule.git", from: "0.1.28"),
    ],
    targets: [
        .target(
            name: "MKLoRaWAN-PBSDK",
            dependencies: ["MKBaseBleModule"],
            path: "MKLoRaWAN-PB/Classes/SDK",
            publicHeadersPath: ".",
            linkerSettings: [.linkedFramework("CoreBluetooth")]
        ),
        .target(
            name: "MKLoRaWAN-PB",
            dependencies: [
                "MKLoRaWAN-PBSDK",
                "MKBaseBleModule",
                "MKBaseModuleLibrary",
                "MKCustomUIModule",
                .product(name: "FMDB", package: "fmdb"),
                .product(name: "MKIotDMApp", package: "mkiotdm_ios"),
                "MKFilterPagesModule",
                .product(name: "MKLoRaCommonModule", package: "LoRaCommonModule"),
            ],
            path: "MKLoRaWAN-PB",
            exclude: ["Classes/SDK"],
            sources: ["Classes"],
            resources: [.process("Assets")],
            cSettings: [
                .headerSearchPath("Classes/CTMediator"),
                .headerSearchPath("Classes/ConnectModule"),
                .headerSearchPath("Classes/DatabaseManager"),
                .headerSearchPath("Classes/SDK"),
                .headerSearchPath("Classes/Target"),
                .headerSearchPath("Classes/Functions/AlarmFunctionPage/Controller"),
                .headerSearchPath("Classes/Functions/AlarmFunctionPage/Model"),
                .headerSearchPath("Classes/Functions/AlarmFunctionPage/View"),
                .headerSearchPath("Classes/Functions/AlertSettingsPage/Controller"),
                .headerSearchPath("Classes/Functions/AlertSettingsPage/Model"),
                .headerSearchPath("Classes/Functions/AxisSettingsPage/Controller"),
                .headerSearchPath("Classes/Functions/AxisSettingsPage/Model"),
                .headerSearchPath("Classes/Functions/BleFixPageModel"),
                .headerSearchPath("Classes/Functions/FilterByRawDataPage/Controller"),
                .headerSearchPath("Classes/Functions/FilterByRawDataPage/Model"),
                .headerSearchPath("Classes/Functions/FilterByRawDataPage/Protocol"),
                .headerSearchPath("Classes/Functions/BleSettingPage/Controller"),
                .headerSearchPath("Classes/Functions/BleSettingPage/Model"),
                .headerSearchPath("Classes/Functions/BleSettingPage/View"),
                .headerSearchPath("Classes/Functions/DeviceInfoPage/Controller"),
                .headerSearchPath("Classes/Functions/DeviceInfoPage/Model"),
                .headerSearchPath("Classes/Functions/DeviceModePage/Controller"),
                .headerSearchPath("Classes/Functions/DeviceModePage/Model"),
                .headerSearchPath("Classes/Functions/DeviceSettingPage/Controller"),
                .headerSearchPath("Classes/Functions/DeviceSettingPage/Model"),
                .headerSearchPath("Classes/Functions/GeneralPage/Controller"),
                .headerSearchPath("Classes/Functions/GeneralPage/Model"),
                .headerSearchPath("Classes/Functions/GpsFixPage/Controller"),
                .headerSearchPath("Classes/Functions/GpsFixPage/Model"),
                .headerSearchPath("Classes/Functions/ManDownPage/Controller"),
                .headerSearchPath("Classes/Functions/ManDownPage/Model"),
                .headerSearchPath("Classes/Functions/ONOFFSettingsPage/Controller"),
                .headerSearchPath("Classes/Functions/ONOFFSettingsPage/Model"),
                .headerSearchPath("Classes/Functions/PositionPage/Controller"),
                .headerSearchPath("Classes/Functions/SOSSettingsPage/Controller"),
                .headerSearchPath("Classes/Functions/SOSSettingsPage/Model"),
                .headerSearchPath("Classes/Functions/ScanPage/Controller"),
                .headerSearchPath("Classes/Functions/ScanPage/Model"),
                .headerSearchPath("Classes/Functions/ScanPage/View"),
                .headerSearchPath("Classes/Functions/SelftestPage/Controller"),
                .headerSearchPath("Classes/Functions/SelftestPage/Model"),
                .headerSearchPath("Classes/Functions/SelftestPage/View"),
                .headerSearchPath("Classes/Functions/TabBarPage/Controller"),
                .headerSearchPath("Classes/Functions/TabBarPage/Model"),

            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("CoreBluetooth"),
            ]
        )
    ]
)
