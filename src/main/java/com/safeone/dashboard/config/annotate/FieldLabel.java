package com.safeone.dashboard.config.annotate;

import java.lang.annotation.*;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface FieldLabel {
    String title() default "";
    String type() default "text";
    int width() default 100;
}