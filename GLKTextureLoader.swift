//
//  Texture.swift
//  Yamato
//
//  Created by Raphaël Calabro on 19/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

enum TextureError : Error {
    case imageNotGenerated
}

extension GLKTextureLoader {

    static func texture(with packMap: PackMap<SpriteBlueprint>) throws -> GLKTextureInfo {
        let imageContext = ImageContext(size: CGSize(width: packMap.size.width, height: packMap.size.height), scale: UIScreen.main.scale)
        
        if let context = imageContext.context {
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
            for (blueprint, origin) in packMap.locations {
                for paintedShape in blueprint.paintedShapes {
                    context.saveGState()
                    paintedShape.paint.paint(shape: paintedShape.shape, rectangle: paintedShape.cgRect(origin: origin, size: blueprint.size), in: context)
                    context.restoreGState()
                }
            }
        }
        
        if let image = imageContext.cgImage {
            #if os(iOS)
                return try GLKTextureLoader.texture(with: image, options: [GLKTextureLoaderOriginBottomLeft: false])
            #elseif os(macOS)
                return try GLKTextureLoader.texture(withContentsOf: temporaryPNGUrl(with: image), options: [GLKTextureLoaderOriginBottomLeft: false])
            #endif
        }
        
        throw TextureError.imageNotGenerated
    }
    
    private static func temporaryPNGUrl(with image: CGImage) -> URL {
        let directories = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let url = NSURL(fileURLWithPath: "\(directories[0])/out.png")
        NSLog("URL : \(url)")
        if let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil) {
            CGImageDestinationAddImage(destination, image, nil)
            if !CGImageDestinationFinalize(destination) {
                NSLog("ERREUR")
            }
        } else {
            NSLog("ERREUR DE CHEMIN")
        }
        return url as URL
    }

}
