package com.safeone.dashboard.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.multipart.MultipartFile;

import com.safeone.dashboard.config.WebConfig;

/**
 *  File 유틸
 *
 *  @version 1.0
 *  @author ekayworks
 *  @since 2017.02.01
*/
public class FileUtils {

    /**
     * 생성자 (생성금지)
     */
    private FileUtils(){}
    
    /**
     * 확장자
     * @param filename 파일이름
     * @return 확장자
     */
    public static String getFileExtension(String filename) {
        return getFilenameAndExtension(filename)[1];
    }

    /**
     * 확장자
     * @param file 파일객체
     * @return 확장자
     */
    public static String getFileExtension(File file) {
        return getFileExtension(file.getName());
    }

    /**
     * 확장자
     * @param file 파일객체
     * @return 확장자
     */
    public static String getFileExtension(MultipartFile file) {
        return getFileExtension(file.getOriginalFilename());
    }
    
    /**
     * 파일명, 확장자 분리
     * @param filename 파일이름
     * @return 파일이름, 확장자 배열
     */
    public static String[] getFilenameAndExtension(String filename) {
        String[] temp = new String[2];
        int index = filename.lastIndexOf(".");
        if (index == -1) {
            temp[0] = filename;
            temp[1] = "";
        } else {
            temp[0] = filename.substring(0, index);
            temp[1] = filename.substring(index + 1);
        }
        return temp;
    }

    /**
     * 유일한 파일이름 구하기 (공백치환 겸용)
     * @param file 파일객체
     * @return 유일한 이름으로 변환된 File 객체
     */
    public static File getUniqueFile(File file) {
        if (!file.exists()) {
            return file;
        }

        File result = file;
        File parent = result.getParentFile();
        
        String regex = "_(\\d+)_$";
        Pattern pattern = Pattern.compile(regex);
        
        while (result.exists()) {
            String filename = result.getName().replaceAll(" ", "_"); //공백을 _로 치환
            String[] filenames = getFilenameAndExtension(filename);

            Matcher m = pattern.matcher(filenames[0]);
            
            if (file.isDirectory()) { // 그 디렉토리가 있어!!
                throw new RuntimeException("디렉토리가 존재함");
            } else if (file.isFile() && m.find()) {
                String numString = m.group(1);
                int num = Integer.parseInt(numString) + 1;
                filename = m.replaceFirst("_" + Integer.toString(num))+ "_" + (filenames[1].equals("")?"":"."+filenames[1]);
                result = new File(parent, filename);
             } else {
                   result = new File(parent, filenames[0] + "_1_" + (filenames[1].equals("")?"":"."+filenames[1]));
            }
        }
        
        return result;
    }
    
    public static String getThumbUrlPath(String originalUrlPath) {
    	int pos = originalUrlPath.lastIndexOf("/");
    	String path = "";
    	String file = "";
    	if (pos > 0) {
    		path = originalUrlPath.substring(0, pos);
    		file = originalUrlPath.substring(pos);
    	}
    	String[] filename = getFilenameAndExtension(file);
    	return path + filename[0] + WebConfig.UPLOADED_IMAGE_THUMB_POSTFIX + "." + filename[1];
    }

    public static String fileSave(String path, byte[] bytes, String fileName)
    {
        fileName = path + File.separator + fileName;

        File f = getUniqueFile(new File(fileName));
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(f);
            fos.write(bytes);
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }

        return f.getAbsolutePath();
    }


    public static File convert(MultipartFile multipart) throws IOException {
        File convFile = new File(multipart.getOriginalFilename());
        multipart.transferTo(convFile);
        return convFile;
    }

}
