package com.safeone.dashboard.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

@Slf4j
@Component
public class ImageTransferUtils {

    @Async
    public void imageTransfer(String imageUrl, String imagePath){
        try {
            URL url = new URL(imageUrl);
            String fileName = imageUrl.substring(imageUrl.lastIndexOf('/')+1);
            String ext = imageUrl.substring(imageUrl.lastIndexOf('.')+1);
            BufferedImage image = ImageIO.read(url);

            ImageIO.write(image, ext, FileUtils.getUniqueFile(new File(imagePath + fileName)));
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
