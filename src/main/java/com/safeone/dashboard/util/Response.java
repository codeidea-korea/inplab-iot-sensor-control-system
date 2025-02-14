package com.safeone.dashboard.util;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Response<T> {
    public static final int OK = 0;

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

}
