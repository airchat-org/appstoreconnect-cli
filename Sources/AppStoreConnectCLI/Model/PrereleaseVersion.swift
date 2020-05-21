// Copyright 2020 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import Foundation
import struct Model.App
import SwiftyTextTable

struct PreReleaseVersion: ResultRenderable {
    var app: App?
    var platform: String?
    var version: String?
    // TODO: var builds: [Build]?
}

extension PreReleaseVersion {
    init(_ preReleaseVersion: AppStoreConnect_Swift_SDK.PrereleaseVersion, _ includes: [AppStoreConnect_Swift_SDK.PreReleaseVersionRelationship]?) {

        let relationships = preReleaseVersion.relationships

        let includedApps = includes?.compactMap { relationship -> AppStoreConnect_Swift_SDK.App? in
          if case let .app(app) = relationship {
            return app
          }
          return nil
        }

        let appDetails = includedApps?.first(where: { relationships?.app?.data?.id == $0.id }) 
        let app = appDetails.map(App.init)

        self.init(
            app: app,
            platform: preReleaseVersion.attributes?.platform?.rawValue,
            version: preReleaseVersion.attributes?.version
        )
    }
}

extension PreReleaseVersion: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "App ID"),
            TextTableColumn(header: "App Bundle ID"),
            TextTableColumn(header: "App Name"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Version"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            app?.id,
            app?.bundleId,
            app?.name,
            platform,
            version
        ].map { $0 ?? "" }
    }
}