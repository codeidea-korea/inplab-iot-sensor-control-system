package com.safeone.dashboard.controller.adminAdd;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequiredArgsConstructor
@RequestMapping("/adminAdd/view")
@Tag(name = "view-controller", description = "view-controller")
public class AddViewController {

	@RequestMapping(value = "/{path1}", method = { RequestMethod.GET })
	public String viewDepth1(@PathVariable String path1, Model model) {
		return "adminAdd/" + path1;
	}

	@RequestMapping(value = "/{path1}/{path2}", method = { RequestMethod.GET })
	public String viewDepth2(@PathVariable String path1, @PathVariable String path2, Model model) {
		return "adminAdd/" + path1 + "/" + path2;
	}
}
