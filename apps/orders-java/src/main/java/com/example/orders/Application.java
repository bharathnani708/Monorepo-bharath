package com.example.orders;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class Application {
    @GetMapping("/healthz") public String healthz() { return "{\"ok\":true,\"service\":\"orders-java\"}"; }
    @GetMapping("/") public String root() { return "Hello from orders-java"; }
    public static void main(String[] args) { SpringApplication.run(Application.class, args); }
}
