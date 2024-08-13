package com.safeone.dashboard.util;

public class Response<T> {
    public static final int OK = 0;
    public static final int UNKNOWN = 9999;

/*    public static final int INVALID_INPUT = 1000; //파라미터 오류

    public static final int ALREADY_EXISTED = 1900;
    public static final int ALREADY_REGISTRATED = 2000; //이미 등록되어 있는 상태
    public static final int NOT_EXIST = 2100; //존재하지 않는 경우

    public static final int INSERT_FAILED = 3000; //db 등록실패
    public static final int UPDATE_FAILED = 3100; //db 변경 실패
    public static final int DELETE_FAILED = 3200; //db 삭제 실패*/

    private T data;
    private int status = OK;
    private String message = "Success";

    public Response(T data, int status, String message) {
        this.data = data;
        this.status = status;
        this.message = message;
    }

    public Response(T data, int status) {
        this.data = data;
        this.status = status;
        this.message = "";
    }

    public Response(T data, int status, Exception e) {
        this.data = data;
        this.status = status;
        this.message = e.getClass() + " " + e.getLocalizedMessage();
    }

    public Response(T data) {
        this.data = data;
        this.status = Response.OK;
        this.message = "";
    }

    public Response(int status, String message) {
        this.status = status;
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
