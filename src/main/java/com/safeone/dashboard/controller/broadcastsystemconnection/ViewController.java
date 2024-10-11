package com.safeone.dashboard.controller.broadcastsystemconnection;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/broadcast-system-connection")
public class ViewController {

	@GetMapping
	public String index() {
		return "broadcast-system-connection/broadcast-system-connection";
	}

}
