/**
 * @author fuqiang[designsor@gamil.com]
 * @version 20120405
 * @fileoverview load local img and convert to base64
 */

package{
    import BitmapUtil;
    import flash.net.FileReference;
    import flash.net.FileFilter; 
    import flash.net.URLRequest; 
    import flash.utils.ByteArray; 
    import flash.display.Loader;

    import mx.graphics.codec.PNGEncoder;
    import mx.utils.Base64Encoder;
    import flash.utils.ByteArray;
    import flash.display.Bitmap;
    import flash.display.BitmapData;


    import flash.display.Sprite;
    import flash.display.LoaderInfo;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.display.Stage;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    public class imgforbase64 extends Sprite {
        private var fileRef:FileReference; 
        private var button:Sprite;
        private var loader:Loader;
        private var finalpic:Bitmap;
        private var flashvars:Object;

        //打开本地图片
        private function openFile(event:Event):void{ 
            fileRef = new FileReference(); 
            fileRef.addEventListener(Event.SELECT, onFileSelected); 
            fileRef.addEventListener(Event.COMPLETE, oncompleteHandler); 
            var textTypeFilter:FileFilter = new FileFilter("Images Files (*.jpg,*.jpeg,*.gif,*.png)","*.jpg;*.jpeg;*.gif;*.png"); 
            fileRef.browse([textTypeFilter]); 
        } 
        //开始本地下载
        private function oncompleteHandler(event:Event):void{
            var fileRef:FileReference = FileReference(event.target);
            loader =new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
            loader.loadBytes(fileRef.data);
        }
        //下载完成触发js回调
        private function onLoadComplete(event:Event):void{
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
            var bitmap:Bitmap = Bitmap(event.target.content);
            var zoompic:BitmapData = BitmapUtil.getZoomDraw(bitmap,flashvars.outwidth,flashvars.outheight,true);
            finalpic = new Bitmap(zoompic,"auto",true);
            var pngStream:ByteArray=(new PNGEncoder).encode(finalpic.bitmapData);
            var base64Enc:Base64Encoder = new Base64Encoder();
            base64Enc.encodeBytes(pngStream);
            var base64Str:String = base64Enc.toString();
            ExternalInterface.call('imgforbase64',base64Str);    
        }
        //选择保存之后的回调
        private function onFileSelected(event:Event):void{
            var fileRef:FileReference = FileReference(event.target);
            fileRef.load();
        }
        //绘制按钮场景
        public function imgforbase64():void{
            //让场景和按钮一样大，不按照比例来
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            flashvars = LoaderInfo(this.root.loaderInfo).parameters;
            //ExternalInterface.call('console.log',flashvars);    
            button = new Sprite();
            button.buttonMode = true;
            button.useHandCursor = true;
            button.graphics.beginFill(0xCCFF00);
            button.graphics.drawRect(0, 0, Math.floor(flashvars.width), Math.floor(flashvars.height));
            button.alpha = 0.0;
            addChild(button);
            button.addEventListener(MouseEvent.CLICK, openFile);
        }
    }
}
