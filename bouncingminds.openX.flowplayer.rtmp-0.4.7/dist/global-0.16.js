
$(function() {

	$("#logout").click(function() {
		return account.logout();
	});

//{{{ messy highlighting stuff

	// highlight global nav
	var els = location.href.split("/");
	var f = "/" + els[3];
	if (f.indexOf("#") != -1) f = f.substring(0, f.indexOf("#"));

	if (f == '/tools') f = '/plugins';
	else if (f == '/documentation' || f == '/tutorials') f = '/demos';
	else if (f == '/index.html' || f == '/') f = "";
	$("#globalnav a").filter("[href=" + f + "/index.html]").addClass("active");

	// hightlight subnav
	var loc = location.href;
	var page = loc.substring(loc.indexOf("/", 10), loc.indexOf("?") > 0 ? loc.indexOf("?") : loc.length);
	if (page.indexOf("#") != -1) {
		page = page.substring(0, page.indexOf("#"));
	}
	var el = $("#right ul a[href=" +page+ "]");
	if (!el.length && (f == 'documentation' || f == 'account')) el = $("#right ul a:first");

	el.addClass("selected").click(function(e) {
		e.preventDefault();
	});

	// remove redundant borders from subnav
	$("#right ul").each(function() {
		$(this).find("a:last").css("borderBottom", 0);
	});


	// setup main title background image
	f = f.substring(1);

	if (f == 'plugins' && els[4] && els[4] != 'index.html') {
		f = els[4];
		if (els[3] == 'tools') f = "tools";
	}

	if (f == 'demos') {
		f = "documentation";
	}

	var title = $("#content h1:first");
	if (f && title.length && title.css("backgroundImage") == 'none') {
		if (f == 'admin') f = 'flowplayer';
		title.css("backgroundImage", "url(http://static.flowplayer.org/img/title/" + f + ".png)");
	}
	//}}}



//{{{ HOME PAGE

	/*
		Scripting of the home page. You can freely study it and steal ideas to your site.
	*/
	if (f == '') {

		$("#demo div.item").show();

		/*
			tabbed navigation uses our jquery.scrollable tool, see:

			http://flowplayer.org/tools/scrollable.html
		*/
		$("#tab_panes").scrollable({
			items: '#items',
			size: 1,
			navi: '#tabs',
			onBeforeSeek: function(i) {
				$f().unload();
				this.getItems().show();

				if (i == 1 && !player.done) {
					player.controls("homeControls", {duration: 25});
					player.done = true;
				}
			}
		});


	//{{{ the player

		// just the player without specialities
		var player = $f("player1", {src:v.core}, {

			// this will enable pseudostreaming support
			plugins: {
				pseudo: { url: v.pseudostreaming },
				controls: {
					backgroundColor:'#000000',
					backgroundGradient: 'low'
				}
			},

			// clip properties
			clip: {
				provider: 'pseudo',
				baseUrl: 'http://pseudo-s3.simplecdn.net',
				url: flashembed.isSupported([9, 115]) ? 'eye-pseudo.mp4' : 'flowplayer-700.flv'
			},

			onFinish: function() {
				this.unload();
			}

		}).embed();


		$("#embedPane textarea").html(player.getEmbedCode());

	//}}}


	//{{{ plugins

		var player = $f("player2", v.core, {
			clip:  {
				scaling:'scale',
				baseUrl: 'http://static.flowplayer.org/video',
				url: flashembed.isSupported([9, 115]) ? 'eye-pseudo.mp4' : 'flowplayer-700.flv',

				onStart: function() {
					var p = this.getPlugin("content");
					p.setHtml($("#content0").html()).fadeTo(0.8, 2000);
				},

				// animation stuff
				onCuepoint: [[8000, 18000], function(clip, point) {
					var c = this.getPlugin("content");

					if (point == 8000) {
						c.setHtml($("#content1").html());
						c.css({background:'#005617', backgroundGradient:'medium'});
						c.animate({bottom:13, height:60}, 2000);

						// screen to the top-left corner
						this.getScreen().animate({top:10,left:10, height:170, width:250}, 3000);

						// hide controls
						this.getControls().animate({top:300});
					}

					// reset
					if (point == 18000) {
						this.reset();
						c.hide();
					}
				}]
			},

			plugins: {

				// content plugin, initially hidden
				content: {
					url:v.content,
					backgroundGradient:'low',
					height:80,
					display: 'none',
					opacity: 0,

					style: {
						body: {fontSize: 16},
						b: {color:'#ffea00', leading: 6}
					}
				},

				controls: null
			},

			onFinish: function() {
				this.unload();
			}

		});

	//}}}


	//{{{ streaming
	$f("player3", {src: v.core, bgcolor: '#112233'}, {

			clip: {
				provider: flashembed.isSupported([9, 115]) ? 'rtmp' : 'pseudo',
				url: flashembed.isSupported([9, 115]) ? null : 'http://pseudo-s3.simplecdn.net/flowplayer-700.flv'
			},

			onBeforeClick: function() {
				var wrap = $(this.getParent());
				wrap.next("div.col").hide();
				wrap.expose({
					opacity:0.9,
					color: null,
					closeOnClick: false,
					onClose: function() {
						$f().unload();
					}
				});

				$(this.getParent()).animate({width: 697, height: 390, marginTop:-24}, 1000, function()  {
					$f(this).load();
					$("#exposeMask").html("<p>This MP4 video is streamed globally using a <em>Content Deliver Network</em> (CDN). Look for the amazing video quality. You can seek randomly anywhere in the timeline. <br /><span>Press ESC to close.</span></p>");
				});

				return false;
			},

			 onUnload: function() {
				 $(this.getParent()).css({width: null, height: null, marginTop: null});
				 $("#exposeMask").html("");
				 $(this.getParent()).next("div.col").fadeIn("slow");
			 },

			plugins: {
			  rtmp: {
					url: v.rtmp,
					netConnectionUrl: 'rtmpt://flash-7.simplecdn.net/play'
			  },

			  pseudo: { url: v.pseudostreaming},

			  controls: {
					autoHide: 'always',
					hideDelay: 500
			  }
			},

			canvas: {
				backgroundGradient: [0.01, 0.03]
			}
		});

	//}}}


	//{{{ scripting


		// setup player into overlayed content
		$f("overlay_player", v.core, {
			clip:  {
				scaling: 'scale',
				url:'http://blip.tv/file/get/KimAronson-TwentySeconds4461.flv',
				onStart: function() {
					var p = this.getPlugin("hello")
					p.animate({left:'50%',top:'50%',height:140,width:'96%',opacity:0.95}, 4000);
				}
			},

			plugins: {

				// controlbar settings
				controls:  {
					backgroundColor:'transparent',
					backgroundGradient:'none',
					height:50,
					bottom:10,
					autoHide:'always',
					all:false,
					play:true,
					scrubber:true
				},

				// content plugin
				hello: {
					url:v.content,
					opacity:0,
					left:0,
					height:0,
					width:0,
					borderRadius:30,
					backgroundColor:'#112233',
					backgroundGradient:'medium',
					padding:20,
					style: {
						p:  {fontSize:28, color:'#ffffff'}
					},
					html:'<img align="right" src="img/title/flash24.png"/><p>A simple scripting example: \"Video overlay\".</p>'
				}
			}
		});


		/*
			when a[rel] is clicked it opens up overlayed video content
			it uses our jquery.overlay tool, see:

			http://flowplayer.org/tools/overlay.html
		*/
		$("a[rel]").overlay({

			// this demo script is run when overlay is in place
			onBeforeLoad: function() {
				this.getBackgroundImage().expose("#123");
			},

			onLoad: function() {
				$f("overlay_player").load();
			},

			// unload player when overlay is closed
			onClose: function() {
				$.expose.close();
				$f().unload();
			}

		});

	//}}}


		// preload largest images for future use
		$(window).load(function() {
			setTimeout(function() {
				var base = "http://static.flowplayer.org/img";
				new Image().src = base + "/commerce/products-hero.jpg";
				new Image().src = base + "/global/sidenav.png";
				new Image().src = base + "/form/btn/login_search.png";
			}, 2000);
		});

	} // end home }}}


	// lazy download of jquery.chili.js
	if ($("code[class]").length) {
		$.getScript("js/chili/jquery.chili-2.2.js");
	}

	// set initial focus on first input field
	var input = $("#right :input[name=login]:visible");
	if (input.length && !location.hash) {
		input.get(0).focus();
	}

	// drawer
	$("#right div.box a.header").click(function(e) {
		var el = $(this);
		var cl = "active";

		if (!el.hasClass(cl)) {
			el.parent().find(".active").removeClass(cl).eq(1).slideUp();
			el.addClass(cl).next().addClass(cl).slideDown(function()  {
				$(this).find(":input").get(0).focus();
			});
			e.preventDefault();
		}
	});

	// mouse tip
	$("div.tip").prev().hover(function(evt) {
		var el = $(this);
		el.next().css({top:evt.pageY - 40, left:evt.pageX + 40}).show();

	}, function()  {
		$(this).next().hide();
	});


	// button.custom, span.play hover and mousedown
	$("button.custom").each(function() {
		var el = $(this);
		if (!el.find("span").length) el.html("<span>" + el.html() + "</span>");
	});

	$("button.custom, span.play").each(function()  {

		var el = $(this);
		var xPos = el.attr("id") == 'searchButton' ? '-100px' : '0';

		el.hover(function() {
			var el =	$(this);
			el.css("backgroundPosition", xPos + " -" + el.css("height"));
		}, function() {
			$(this).css("backgroundPosition", xPos + " 0");
		}).mousedown(function()  {
			var el =	$(this);
			el.css("backgroundPosition", xPos + " -" + (parseInt(el.css("height")) * 2) + "px");
		});

	});




	$("a.player").hover(function() {
		$("img", this).fadeTo(400, 1);
	}, function() {
		$("img", this).fadeTo(400, 0.7);

	}).find("img").css({opacity:0.7});


	// latest posts
	$("#latestPosts h2").click(function() {
		var posts = $(this).next("ul");
		posts.slideToggle(function()  {
			document.cookie = 'postsDisplay=' + posts.css("display");
			$("#toggle").css("backgroundPosition", "0 " + (posts.is(":visible") ? "-13" : "0") + "px");
		});
	});


	$("#latestPosts a").click(function() {
		$("#latestPosts a").removeClass("selected");
		$(this).addClass("selected");
	});



	// make right side picks clicable
	$("#right div.pick").click(function() {
	  location.href = $(this).find("a").attr("href");
	});


	// download statistics
	$(".download").each(function()  {
		var el = $(this);

		el.click(function() {
			google._trackPageview(el.attr("href"));

		}).bind("contextmenu", function() {
			google._trackPageview(el.attr("href"));

		});
	});

});


// global functions
var account = {

	admin: false,

	login: function(form) {
		form = $(form);
		$.post("/account/login?" + form.serialize(), function(res) {
			res = eval("(" + res + ")");
			if (res.message) {
				form.find("div.error").html(res.message).show();
			} else {

				if (location.href.indexOf("download") != -1) {
					location.href = "/account/products.html";
				} else {
					location.reload();
				}
			}
		});

		return false;
	},


	create: function(form) {
		form = $(form);
		$.post("/account/create?" + form.serialize(), function(res) {
			res = eval("(" + res + ")");
			if (res.message) {
				form.find("div.error").html(res.message).show();
			} else {
				form.html(
					"Your account was successfully created. " +
					"Your new password was sent to you by email"
				);
			}
		});

		return false;
	},


	requestPassword: function(form) {
		form = $(form);
		$.getJSON("/account/requestPassword?" + form.serialize(), function(json) {
			if (json.message) {
				form.find("div.error").html(json.message).show();
			} else {
				form.html("Your new password was sent to you by email");
			}
		});

		return false;
	},


	logout: function()  {
		$.get("/account/logout", function() {
			location.reload();
		});
		return false;
	}

};

var site = {

	uploadDone: function(fileName, hostId) {
		var img = hostId ? $("div.hostPicture[hostId=" + hostId + "] img") : $("#picture");
		img.attr("src", "/img/users/" + fileName + "?_=" + Math.random());
	},

	submitForm: function(form, to) {
		form = $(form);
		form.fadeTo(400, 0.3);

		$.getJSON(form.attr("action") + "?" + form.serialize(), function(json) {
			form.fadeTo(400, 1);

			if (json.message) {
				form.find("div.error").html(json.message).show();

			} else {
				if (to)  {
					location.href = to;
				} else  {
					location.reload();
				}
			}
		});

		return false;
	}

}


$(function() {

	// email and embed tab actions
	$("#shareTabs a").click(function(e)  {
		$f().hide(true);

		// toggle tab class
		var tab = $(this);
		$("#shareTabs a").removeClass("current");
		tab.addClass("current");

		// show / hide panes
		$(tab.attr("href")).show();
		var other = (tab.attr("href") == "#emailPane") ? $("#embedPane") : $("#emailPane");
		other.hide();

		// prevent link's default behaviour
		return e.preventDefault();
	});

	// close buttons
	$("#panes div.close").click(function() {
		$("#shareTabs a").removeClass("current");
		$("#emailPane, #embedPane").hide();
		$f().show();
	});

	/*
		email form setup. depends on simple JSON responses of the form
			- on error: {message: 'error message'}
			- otherwise it's successs
	*/
	$("#shareForm").submit(function(e) {

		var form = $(this);
		form.fadeTo(500, 0.1);

		$.getJSON(form.attr("action") + "?" + form.serialize() + "&format=json&jsoncallback=?", function(json) {
			form.fadeTo(500, 1);
			var info = $("#info").show();

			if (json.message) {
				info.html(json.message);
			} else {
				info.html("Email was successfully sent");
			}
		});

		e.preventDefault();
		return false;
	});

});
