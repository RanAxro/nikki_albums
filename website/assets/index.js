	// Theme Toggle Logic
	function toggleTheme() {
		const isLight = document.documentElement.classList.contains('light-mode');
		if (isLight) {
			document.documentElement.classList.remove('light-mode');
			localStorage.setItem('theme', 'dark');
		} else {
			document.documentElement.classList.add('light-mode');
			localStorage.setItem('theme', 'light');
		}
	}
	
	// Watch for system preference changes
	window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', e => {
		if (!localStorage.getItem('theme')) {
			if (e.matches) {
				document.documentElement.classList.add('light-mode');
			} else {
				document.documentElement.classList.remove('light-mode');
			}
		}
	});

	// Translation Dictionary
	const i18n = {
		zh: {
			page_title: "暖暖相册 - 一款用于管理你的无限暖暖相册的工具",
			app_name: "暖暖相册",
			nav_qq: "交流群1062670402",
			nav_tutorial: "教程",
			nav_download: "下载",
			hero_title: "暖暖相册",
			hero_desc: "一款专为《无限暖暖》玩家精心打造的相册管理软件",
			hero_subdesc: "轻松、高效地管理游戏相册，让游戏体验更加畅快无忧。免费开源，无广告。",
			btn_download: "立即下载",
			btn_github: "GitHub 仓库",
			compat_hint: "支持 Windows 10/11 和 macOS (M系列芯片)",
			tab_wall: "相册概览",
			tab_decode: "参数解码",
			card_1_title: "多种相册管理",
			card_1_desc: "支持查看 19 类相册与 3 类游戏内部资源，涵盖日常、趣拼、动态影集等。",
			card_2_title: "相机参数解码",
			card_2_desc: "自动解码相机光圈、焦距、滤镜参数及拍摄坐标，轻松复现精美构图。",
			card_3_title: "高效批量操作",
			card_3_desc: "支持批量导出、还原、转移、删除、移动，内置智能去重，管理更省心。",
			card_4_title: "动图与实况转换",
			card_4_desc: "一键将视频或动态影集转换为 GIF 动图或 macOS 系统实况照片 (Live Photo)。",
			card_5_title: "多渠道导出分享",
			card_5_desc: "支持复制到剪贴板，支持局域网或同一网络设备无损导出，分享快人一步。",
			footer_disclaimer: "暖暖相册并非《无限暖暖》官方或叠纸游戏的官方产品。所有素材版权归原公司所有。",
			modal_title: "首次运行 macOS 版的重要提示",
			modal_desc: "由于当前程序是免签名的便携版，首次打开可能会被系统拦截。<br><br>请按照以下步骤正常打开：<br>1. 若弹出“Apple 无法检查 App 是否包含恶意软件”，请点按 <b>好</b>。<br>2. 打开系统的 <b>系统设置</b> > <b>隐私与安全性</b>。<br>3. 前往“安全性”部分，找到关于 Nikki Albums 的提示，然后点按 <b>打开</b>。<br>4. 点按 <b>仍要打开</b>，输入你的登录密码，然后点按 <b>好</b>。",
			modal_btn: "我已了解"
		},
		en: {
			page_title: "Nikki Albums - A photo album manager for Infinity Nikki",
			app_name: "Nikki Albums",
			nav_qq: "QQ Group 1062670402",
			nav_tutorial: "Tutorial",
			nav_download: "Download",
			hero_title: "Nikki Albums",
			hero_desc: "An elegant and efficient photo album manager built for Infinity Nikki players",
			hero_subdesc: "Easily manage your in-game photo albums across multiple accounts. Fully open-source and completely free.",
			btn_download: "Download Now",
			btn_github: "GitHub Repo",
			compat_hint: "Supports Windows 10/11 & macOS (Apple Silicon)",
			tab_wall: "Album Showcase",
			tab_decode: "Metadata Decoder",
			card_1_title: "Diverse Albums",
			card_1_desc: "Supports viewing 19 album categories and 3 game resource types, including video albums.",
			card_2_title: "Metadata Decoding",
			card_2_desc: "Extracts aperture, focal length, filters, and coordinates to help reproduce your best shots.",
			card_3_title: "Batch Processing",
			card_3_desc: "Batch export, restore, transfer, delete, and move with smart duplicate detection.",
			card_4_title: "Live Photo & GIF Maker",
			card_4_desc: "Convert game video albums to animated GIFs or macOS Live Photos seamlessly.",
			card_5_title: "Easy Export",
			card_5_desc: "Export losslessly to the clipboard or transfer directly to network devices.",
			footer_disclaimer: "Nikki Albums is an open-source tool and is not affiliated with Infinity Nikki or Papergames. All copyrights belong to their respective owners.",
			modal_title: "Important Note for macOS Users",
			modal_desc: "Since this is an ad-hoc signed app, macOS Gatekeeper might block it on the first run.<br><br>Please follow these steps to open it normally:<br>1. If a dialog says \"Apple can't check app for malicious software\", click <b>OK</b>.<br>2. Open <b>System Settings</b> > <b>Privacy & Security</b>.<br>3. Under the \"Security\" section, locate Nikki Albums and click <b>Open</b>.<br>4. Click <b>Open Anyway</b>, enter your login password, and click <b>OK</b>.",
			modal_btn: "Got it"
		}
	};

	let currentLang = 'zh';
	let activeTab = 'wall';

	// Language selection
	function initLang() {
		const saved = localStorage.getItem('lang');
		if (saved && (saved === 'zh' || saved === 'en')) {
			currentLang = saved;
		} else {
			// Auto detect browser language
			const navLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase();
			if (navLang.startsWith('zh')) {
				currentLang = 'zh';
			} else {
				currentLang = 'en';
			}
		}
		applyLang();
	}

	// Language dropdown controls
	function toggleLangDropdown(e) {
		e.stopPropagation();
		const trigger = document.getElementById('lang-dropdown-trigger');
		const menu = document.getElementById('lang-dropdown-menu');
		trigger.classList.toggle('active');
		menu.classList.toggle('show');
	}

	function selectLang(lang) {
		switchLang(lang);
		const trigger = document.getElementById('lang-dropdown-trigger');
		const menu = document.getElementById('lang-dropdown-menu');
		if (trigger && menu) {
			trigger.classList.remove('active');
			menu.classList.remove('show');
		}
	}

	// Close dropdown when clicking outside
	window.addEventListener('click', () => {
		const trigger = document.getElementById('lang-dropdown-trigger');
		const menu = document.getElementById('lang-dropdown-menu');
		if (trigger && menu) {
			trigger.classList.remove('active');
			menu.classList.remove('show');
		}
	});

	function switchLang(lang) {
		currentLang = lang;
		localStorage.setItem('lang', lang);
		applyLang();
	}

	function applyLang() {
		// Update dropdown trigger label and items active class
		const zhItem = document.getElementById('item-lang-zh');
		const enItem = document.getElementById('item-lang-en');
		const currentLangLabel = document.getElementById('current-lang-label');
		
		if (zhItem && enItem && currentLangLabel) {
			zhItem.classList.toggle('active', currentLang === 'zh');
			enItem.classList.toggle('active', currentLang === 'en');
			currentLangLabel.textContent = currentLang === 'zh' ? '简体中文' : 'English';
		}
		
		// Update dynamic text
		const dict = i18n[currentLang];
		document.querySelectorAll('[data-i18n]').forEach(el => {
			const key = el.getAttribute('data-i18n');
			if (dict[key]) {
				if (el.tagName === 'TITLE') {
					document.title = dict[key];
				} else {
					el.innerHTML = dict[key];
				}
			}
		});

		// Update link paths
		document.getElementById('nav_download').href = `website/pages/download.html?lang=${currentLang}`;
		document.getElementById('nav_download_mobile').href = `website/pages/download.html?lang=${currentLang}`;
		
		// Hide QQ Group links for non-Chinese versions
		document.querySelectorAll('.zh-only').forEach(el => {
			el.style.display = currentLang === 'zh' ? '' : 'none';
		});

		// Update screenshots based on current language
		updateShowcaseImages();
	}

	// Showcase Switch
	function switchShowcaseTab(tab) {
		activeTab = tab;
		
		// Tab buttons class
		document.getElementById('tab-wall').classList.toggle('active', tab === 'wall');
		document.getElementById('tab-decode').classList.toggle('active', tab === 'decode');

		// Image toggle
		document.getElementById('img-wall').classList.toggle('active', tab === 'wall');
		document.getElementById('img-decode').classList.toggle('active', tab === 'decode');
	}

	function updateShowcaseImages() {
		const wallImg = document.getElementById('img-wall');
		const decodeImg = document.getElementById('img-decode');
		
		if (currentLang === 'zh') {
			wallImg.src = 'website/assets/p1.zh.png';
			decodeImg.src = 'website/assets/p2.zh.png';
		} else {
			wallImg.src = 'website/assets/p1.en.png';
			decodeImg.src = 'website/assets/p2.en.png';
		}
	}

	// Mobile Navigation Drawer Toggle
	function toggleMobileNav() {
		const drawer = document.getElementById('mobile-drawer');
		drawer.classList.toggle('open');
	}

	// Close Mobile Drawer when a link is clicked
	document.querySelectorAll('#mobile-drawer a').forEach(link => {
		link.addEventListener('click', () => {
			document.getElementById('mobile-drawer').classList.remove('open');
		});
	});

	// Download logic
	function handleMainDownload(e) {
		e.preventDefault();
		
		const isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
		const versions = Object.keys(config);
		if (versions.length === 0) return;
		
		const latestVersion = versions[0];
		const latestData = config[latestVersion];
		
		let downloadLink = '';
		
		if (isMac) {
			const macItem = latestData.downloads.find(d => d.system === 'system_macos');
			if (macItem) {
				downloadLink = macItem.link;
			}
		} else {
			const winItem = latestData.downloads.find(d => d.system === 'system_windows' && d.suffix === 'suffix_zip' && d.type === 'type_1') 
						 || latestData.downloads.find(d => d.system === 'system_windows' && d.suffix === 'suffix_exe')
						 || latestData.downloads.find(d => d.system === 'system_windows');
			if (winItem) {
				downloadLink = winItem.link;
			}
		}
		
		if (!downloadLink) {
			window.location.href = `website/pages/download.html?lang=${currentLang}`;
			return;
		}
		
		window.location.href = downloadLink;
		
		if (isMac) {
			document.getElementById('macOsModal').classList.add('active');
		}
	}
	
	function closeMacOsModal() {
		document.getElementById('macOsModal').classList.remove('active');
	}
