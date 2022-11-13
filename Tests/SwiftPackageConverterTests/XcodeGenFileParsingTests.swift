//
//  XcodeGenFileParsingTests.swift
//  
//
//  Created by Albert Bori on 11/5/22.
//

import XCTest
@testable import SwiftPackageConverter

final class XcodeGenFileParsingTests: XCTestCase {
    
    func testXcodegenStaticModule() throws {
//        let expected = XcodegenFile(
//            name: "Logging",
//            include: .init(path: "../../Scripts/xcodegen/default-configs.yml", relativePaths: false),
//            projectReferences: [:],
//            targets: [
//                "Logging": .init(
//                    platform: "",
//                    type: "",
//                    sources: [
//                        .init(stringLiteral: "Sources/Logging")
//                    ],
//                    scheme: .init(testTargets: ["LoggingTests"]),
//                    dependencies: [
//                        .init(framework: "SharedTypes.framework", link: true, implicit: true),
//                        .init(package: "AppPackage", product: "AppSwiftPMDependencies")
//                    ],
//                    templates: [
//                        "StaticLibrary",
//                        "ConfigurationFiles"
//                    ],
//                    postBuildScripts: []
//                )
//            ]
//        )
//        let output = try YAMLDecoder().decode(XcodegenFile.self, from: xcodegenFileStatic)
//        XCTAssertEqual(output.name, "Logging")
//        XCTAssertEqual(output.targets.count, 3)
    }
}

extension XcodeGenFileParsingTests {
    var xcodegenFileStatic: String {
"""
name: Logging
include:
  - path: ../../Scripts/xcodegen/default-configs.yml
    relativePaths: false
targets:
  Logging:
    sources: Sources/Logging
    scheme:
      testTargets:
        - LoggingTests
    dependencies:
      - framework: SharedTypes.framework
        implicit: true
        link: true
      - package: AppPackage
        product: AppSwiftPMDependencies
    templates:
      - StaticLibrary
      - ConfigurationFiles
      
  LoggingMocks:
    sources: Sources/LoggingMocks
    dependencies:
      - framework: SharedTypes.framework
        implicit: true
        link: true
      - package: AppPackage
        product: AppSwiftPMDependencies
      - target: Logging
    templates:
      - StaticLibrary
      - ConfigurationFiles

  LoggingTests:
    sources: Tests/LoggingTests
    dependencies:
      - framework: SharedTypesMocks.framework
        implicit: true
      - package: AppPackage
        product: AppSwiftPMDependencies
      - target: Logging
      - target: LoggingMocks
    templates:
      - UnitTests
      - ConfigurationFiles

"""
    }
    var xcodegenFileDynamic: String {
"""
name: Checkout
include:
  - path: ../../Scripts/xcodegen/default-configs.yml
    relativePaths: false
fileGroups:
  - README.md
targets:
  Checkout:
    scheme:
      testTargets:
        - CheckoutTests
    dependencies:
      - package: AppPackage
        product: AppSwiftPMDependencies
      - package: payBright-iOS-build
        product: PayBright-wrapper
      - framework: Payments.framework
        implicit: true
        link: true
      - framework: UIComponentsShipping.framework
        implicit: true
        link: true
      - framework: Permissions.framework
        implicit: true
        link: true
      - framework: Base.framework
        implicit: true
        link: true
      - framework: Core.framework
        implicit: true
        link: true
      - framework: Models.framework
        implicit: true
        link: true
      - framework: StorefrontCore.framework
        implicit: true
        link: true
      - framework: WayfairCore.framework
        implicit: true
        link: true
      - framework: WayfairUI.framework
        implicit: true
        link: true
      - framework: WebService.framework
        implicit: true
        link: true
      - framework: FeatureSupport.framework
        implicit: true
        link: true
    templates:
      - StaticLibrary
      - ConfigurationFiles

  CheckoutDemo:
    dependencies:
      - target: Checkout
    templates:
      - Demo
      - FeatureDependencies
      - DemoAppDependencies
      - ConfigurationFiles

  CheckoutTests:
    dependencies:
      - package: AppPackage
        product: AppSwiftPMDependencies
      - target: Checkout
      - framework: FeatureSupport.framework
        implicit: true
        link: true
      - framework: FeatureSupportTestSupport.a
        implicit: true
      - framework: ExtendedRealityMocks.framework
        implicit: true
      - framework: ShippingCoreMocks.a
        implicit: true
        link: true
      - framework: NavigationMocks.a
        implicit: true
        link: true
      - framework: CoreTestSupport.framework
        implicit: true
      - framework: StorefrontCoreTestSupport.framework
        implicit: true
      - framework: TestUtilities.framework
        implicit: true
      - framework: WayfairCoreTestSupport.framework
        implicit: true
    templates:
      - UnitTests
      - ConfigurationFiles

"""
    }
    var template: String {
"""
packages:
  sodium-iOS-build:
    url: git@github.csnzoo.com:shared/sodium-iOS-build.git
    exactVersion: 0.9.2
  riskifiedBeacon-iOS-build:
    url: git@github.csnzoo.com:shared/riskifiedBeacon-iOS-build.git
    exactVersion: 1.2.10
  perimeterX-iOS-build:
    url: git@github.csnzoo.com:shared/perimeterX-iOS-build.git
    exactVersion: 1.13.9
  payBright-iOS-build:
    url: git@github.csnzoo.com:shared/payBright-iOS-build.git
    exactVersion: 0.1.8
  fraudForce-iOS-build:
    url: git@github.csnzoo.com:shared/fraudForce-iOS-build.git
    exactVersion: 5.3.1
  firebase-ios-dependencies:
    url: git@github.csnzoo.com:shared/firebase-ios-dependencies.git
    exactVersion: 8.9.1
  tmx-ios-dependencies:
    url: git@github.csnzoo.com:shared/ios-tmx-frameworks.git
    exactVersion: 6.2.84
  userleap-iOS-build:
     url: git@github.csnzoo.com:shared/userleap-iOS-build.git
     exactVersion: 4.7.0
  mux-stats-sdk-avplayer:
     url: https://github.com/muxinc/mux-stats-sdk-avplayer.git
     exactVersion: 2.13.2
  AppPackage:
    path: ../../swiftpmdependencies
attributes:
  LastUpgradeCheck: '1499'
  LastSwiftUpdateCheck: '1499'
configs:
  Debug: debug
  Release: release
configFiles:
  Debug: xcconfigs/Project.xcconfig
  Release: xcconfigs/Project.xcconfig
options:
  settingPresets: none
  defaultConfig: Release

targetTemplates:
  DynamicFramework:
    platform: iOS
    type: framework
    sources: Sources

  # This will be replaced with our Tools/GraphQLTooling in the future
  GraphQLDynamicFramework:
    platform: iOS
    type: framework
    sources:
      #- path: Sources Add custom path per target
      - path: Resources
        optional: true
      - path: Resources/GraphQL.generated.plist
        optional: true
      - path: FileLists
        buildPhase: none

  # This will be replaced with our Tools/GraphQLTooling in the future
  GraphQLPListGenerator:
    preBuildScripts:
      - script: env -i "$(git rev-parse --show-toplevel)/Scripts/build/graphql/generate-hashes.swift" ${SRCROOT}
        name: Generate GraphQL Hashes File
        inputFileLists:
          - $(SRCROOT)/FileLists/GraphQL.xcfilelist
        outputFiles:
          - $(SRCROOT)/Resources/GraphQL.generated.plist

  StaticLibrary:
    platform: iOS
    type: library.static
    sources: Sources

  PactTests:
    platform: iOS
    type: bundle.unit-test
    sources: PactTests

  UnitTests:
    platform: iOS
    type: bundle.unit-test
    sources: Tests

  UITests:
    platform: iOS
    type: bundle.ui-testing
    sources: UITests

  TestSupport:
    platform: iOS
    type: framework
    sources: TestSupport

  ResourceBundle:
    platform: iOS
    type: bundle
    sources: Resources

  GraphQLResourceBundle:
    platform: iOS
    type: bundle
    sources:
    - path: Resources
    - path: Resources/GraphQL.generated.plist
      optional: true
    - path: FileLists
      buildPhase: none

  Demo:
    platform: iOS
    type: application
    sources: Demo
    scheme:
      configVariants: [] # There are no variants, just the one non-varying target.
    postBuildScripts:
      - script: '"${PROJECT_DIR:?}"/../../Scripts/build/graphql/local-graphql-upload.sh'
        name: Upload All GraphQL Queries (when building locally)

  App:
    platform: iOS
    type: application
    sources:
      - Sources
      - xcconfigs
    scheme:
      configVariants: [] # There are no variants, just the one non-varying target.

  AppCustomScheme:
    platform: iOS
    type: application
    sources:
      - Sources
      - xcconfigs

  AppExtension:
    platform: iOS
    type: app-extension
    
  FeatureDependencies:
    dependencies:
      - framework: Base.framework
        implicit: true
        link: true
      - framework: Core.framework
        implicit: true
        link: true
      - framework: Models.framework
        implicit: true
        link: true
      - framework: StorefrontCore.framework
        implicit: true
        link: true
      - framework: WayfairCore.framework
        implicit: true
        link: true
      - framework: WayfairUI.framework
        implicit: true
        link: true
      - framework: WebService.framework
        implicit: true
        link: true
      - framework: FeatureSupport.framework
        implicit: true
        link: true

  DemoAppDependencies:
    dependencies:
      - package: payBright-iOS-build
        product: PayBright-wrapper
      - package: sodium-iOS-build
        product: Sodium-wrapper
      - package: riskifiedBeacon-iOS-build
        product: Riskified-wrapper
      - package: fraudForce-iOS-build
        product: FraudForce-wrapper
      - package: tmx-ios-dependencies
        product: TMX-wrapper
      - framework: DemoSupport.framework
        implicit: true
        embed: true
      - framework: UIComponentsFoundationSwiftUI.framework
        implicit: true
        embed: true
      - package: AppPackage
        product: AppSwiftPMDependencies
        embed: true
    templates:
      - FeatureSupportDependencies
      - UIComponents3DCommonDependencies
      - WayfairUIDependencies

  FeatureSupportDependencies:
    dependencies:
      - framework: UIComponentsAccount.framework
        implicit: true
        link: true
      - framework: UIComponentsCheckout.framework
        implicit: true
        link: true
      - framework: UIComponentsPDP.framework
        implicit: true
        link: true
      - framework: UIComponentsShipping.framework
        implicit: true
        link: true

  WayfairUIDependencies:
    dependencies:
      - framework: UIComponentsBrowse.framework
        implicit: true
        link: true

  UIComponents3DCommonDependencies:
    dependencies:
      - framework: UIComponentsStoresAndGeos.framework
        implicit: true
        link: true
      - framework: UIComponentsCommon.framework
        implicit: true
        link: true
      - package: AppPackage
        product: AppSwiftPMDependencies

  UnitTestDependencies:
    dependencies:
      - framework: CoreTestSupport.framework
        implicit: true
      - framework: StorefrontCoreTestSupport.framework
        implicit: true
      - framework: TestUtilities.framework
        implicit: true
      - framework: WayfairCoreTestSupport.framework
        implicit: true
      - package: AppPackage
        product: AppSwiftPMDependencies

  UITestsDependencies:
    dependencies:
      - framework: UITestSupport.framework
        implicit: true
      - framework: SharedResources.framework
        implicit: true
      - package: AppPackage
        product: AppSwiftPMDependencies

  ConfigurationFiles:
    configFiles:
      Debug: xcconfigs/${target_name}.xcconfig
      Release: xcconfigs/${target_name}.xcconfig

# configVariants is only included since it is a required field. https://github.com/yonaskolb/XcodeGen/blob/629e568/Docs/ProjectSpec.md#target-scheme

schemeTemplates:
  PactTestsScheme:
    build:
      targets:
        ${targetName}: "all"
        ${testTargetName}: ["test"]
    test:
      targets:
        - name: ${testTargetName}
      preActions:
        - script: rm "${PROJECT_DIR:?}/../../output/pact.log" "${PROJECT_DIR:?}/../../output/pacts/*"
          settingsTarget: ${testTargetName}
        - script: pact-mock-service start --pact-specification-version 2.0.0 --log "${PROJECT_DIR:?}/../../output/pact.log" --pact-dir "${PROJECT_DIR:?}/../../output/pacts" -p 1234
          settingsTarget: ${testTargetName}
      postActions:
        - script: pact-mock-service stop
          settingsTarget: ${testTargetName}
        - script: pact-broker publish "${PROJECT_DIR:?}/../../output/pacts" --consumer-app-version="1.0.0" --broker-base-url="http://pactbroker.service.intraiad1.devconsul.csnzoo.com"
          settingsTarget: ${testTargetName}

"""
    }
}
