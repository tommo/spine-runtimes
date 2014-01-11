/******************************************************************************
 * Spine Runtime Software License - Version 1.1
 * 
 * Copyright (c) 2013, Esoteric Software
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms in whole or in part, with
 * or without modification, are permitted provided that the following conditions
 * are met:
 * 
 * 1. A Spine Essential, Professional, Enterprise, or Education License must
 *    be purchased from Esoteric Software and the license must remain valid:
 *    http://esotericsoftware.com/
 * 2. Redistributions of source code must retain this license, which is the
 *    above copyright notice, this declaration of conditions and the following
 *    disclaimer.
 * 3. Redistributions in binary form must reproduce this license, which is the
 *    above copyright notice, this declaration of conditions and the following
 *    disclaimer, in the documentation and/or other materials provided with the
 *    distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

package spine.flash {
import flash.display.Bitmap;
import flash.display.BitmapData;

import spine.atlas.AtlasPage;
import spine.atlas.AtlasRegion;
import spine.atlas.TextureLoader;

public class FlashTextureLoader implements TextureLoader {
	public var bitmapDatas:Object = {};
	public var singleBitmapData:BitmapData;

	/** @param bitmaps A Bitmap or BitmapData for an atlas that has only one page, or for a multi page atlas an object where the 
	 * key is the image path and the value is the Bitmap or BitmapData. */
	public function FlashTextureLoader (bitmaps:Object) {
		if (bitmaps is BitmapData) {
			singleBitmapData = BitmapData(bitmaps);
			return;
		}
		if (bitmaps is Bitmap) {
			singleBitmapData = Bitmap(bitmaps).bitmapData;
			return;
		}

		for (var path:* in bitmaps) {
			var object:* = bitmaps[path];
			var bitmapData:BitmapData;
			if (object is BitmapData)
				bitmapData = BitmapData(object);
			else if (object is Bitmap)
				bitmapData = Bitmap(object).bitmapData;
			else
				throw new ArgumentError("Object for path \"" + path + "\" must be a Bitmap or BitmapData: " + object);
			bitmapDatas[path] = bitmapData;
		}
	}

	public function loadPage (page:AtlasPage, path:String) : void {
		var bitmapData:BitmapData = singleBitmapData || bitmapDatas[path];
		if (!bitmapData)
			throw new ArgumentError("BitmapData not found with name: " + path);
		page.rendererObject = bitmapData;
		page.width = bitmapData.width;
		page.height = bitmapData.height;
	}
	
	public function loadRegion (region:AtlasRegion) : void {
	}

	public function unloadPage (page:AtlasPage) : void {
		BitmapData(page.rendererObject).dispose();
	}
}

}