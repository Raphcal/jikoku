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
            return try GLKTextureLoader.texture(with: image, options: [GLKTextureLoaderOriginBottomLeft: false])
        }
        
        throw TextureError.imageNotGenerated
    }

}
