	
// 获取页面语言（从URL path、localStorage、或浏览器locale获取）
const supported = ['zh','zh-tw','en','ja','ko','fr','de','es','it','pt','id','th'];
function getPageLanguage(){
	const pathParts = window.location.pathname.split('/').filter(p => p);
	const pathLang = pathParts.length > 0 ? pathParts[0] : null;
	if (pathLang && supported.includes(pathLang)) {
		localStorage.setItem('lang', pathLang); // Sync localStorage
		return pathLang;
	}
	const saved = localStorage.getItem('lang');
	if (saved && supported.includes(saved)) {
		return saved;
	}
	const navLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase();
	if (navLang.startsWith('zh')) {
		if (navLang.includes('tw') || navLang.includes('hk') || navLang.includes('hant')) {
			return 'zh-tw';
		}
		return 'zh';
	} else if (navLang.startsWith('ja')) {
		return 'ja';
	} else if (navLang.startsWith('ko')) {
		return 'ko';
	} else if (navLang.startsWith('fr')) {
		return 'fr';
	} else if (navLang.startsWith('de')) {
		return 'de';
	} else if (navLang.startsWith('es')) {
		return 'es';
	} else if (navLang.startsWith('it')) {
		return 'it';
	} else if (navLang.startsWith('pt')) {
		return 'pt';
	} else if (navLang.startsWith('id')) {
		return 'id';
	} else if (navLang.startsWith('th')) {
		return 'th';
	} else {
		return 'en';
	}
}

// 翻译函数 - 自动根据页面语言选择，未找到则使用中文
function tr(key){
	const currentLang = getPageLanguage();
	const value = lang[key];
	
	if (!value) return key;
	
	// 优先使用当前语言，未找到则回退到中文
	return value[currentLang] || value['zh'] || key;
}



// SVG颜色滤镜
const svgColorFilter = {
	indigo: "invert(39%) sepia(15%) saturate(1311%) hue-rotate(194deg) brightness(93%) contrast(89%)",
	indigoDark: "invert(14%) sepia(33%) saturate(3709%) hue-rotate(220deg) brightness(94%) contrast(101%)",
	purple: "invert(52%) sepia(93%) saturate(1587%) hue-rotate(211deg) brightness(97%) contrast(94%)"
};


// 获取最新版本
function getLatestVersion(){
	const versions = Object.keys(config);
	return versions[0];
}

// 获取所有版本列表
function getVersions(){
	return Object.keys(config);
}

// 获取版本描述（根据当前语言）
function getVersionDescription(version){
	const currentLang = getPageLanguage();
	const versionData = config[version];
	
	if(!versionData || !versionData.description) return '';
	
	// 优先使用当前语言，未找到则回退到中文
	return versionData.description[currentLang] || versionData.description['zh'] || '';
}

let currentVersion = getLatestVersion();
let isDropdownOpen = false;


// 设置所有静态文字
function setStaticText(){
	const currentLang = getPageLanguage();
	document.documentElement.lang = currentLang === 'zh' ? 'zh-CN' : 'en-US';

	document.title = tr("page_title");
	document.getElementById("appTitle").textContent = tr("app_name");
	document.querySelector(".logo img").alt = tr("alt_logo");
	document.getElementById("selectVersionLabel").textContent = tr("select_version");
	document.getElementById("currentVersion").textContent = currentVersion;
	document.getElementById("arrowDownIcon").alt = tr("alt_arrow_down");
	document.getElementById("arrowDownIcon").style.filter = svgColorFilter.indigo;
	document.getElementById("scrollHintText").textContent = tr("scroll_hint_text");
	document.getElementById("scrollHintBtn").title = tr("scroll_hint_title");
	document.getElementById("chevronDownIcon").alt = tr("alt_chevron_down");
	document.getElementById("chevronDownIcon").style.filter = svgColorFilter.indigo;
	document.getElementById("footerText").textContent = tr("footer_tip");
}

// 初始化
function init(){
	const versions = getVersions();
	const latestVersion = getLatestVersion();
	const dropdownMenu = document.getElementById('dropdownMenu');
	const contentsContainer = document.getElementById('downloadContents');
	
	// 设置静态文字
	setStaticText();
	

	
	// 绑定下拉框点击事件
	document.getElementById('dropdownTrigger').addEventListener('click', function(e){
		e.preventDefault();
		e.stopPropagation();
		toggleDropdown();
	});
	
	// 绑定滚动提示按钮点击事件
	document.getElementById('scrollHintBtn').addEventListener('click', function(e){
		e.preventDefault();
		e.stopPropagation();
		scrollToBottom();
	});
	
	// 生成下拉菜单选项
	versions.forEach(version => {
		const versionData = config[version];
		const isLatest = version === latestVersion;
		const isSelected = version === currentVersion;
		
		const item = document.createElement('div');
		item.className = `dropdown-item ${isSelected ? 'selected' : ''}`;
		
		let badgeHtml = '';
		if(isLatest){
			badgeHtml = `<span class="latest-badge">${tr("latest_badge")}</span>`;
		}
		
		item.innerHTML = `
			<div class="dropdown-item-content">
				<span class="dropdown-item-text">${version}</span>
				${badgeHtml}
			</div>
			<div class="dropdown-item-check">
				<img src="${icons.check}" alt="${tr("alt_check")}" style="filter: ${svgColorFilter.purple};">
			</div>
		`;
		
		item.addEventListener('click', function(e){
			e.preventDefault();
			e.stopPropagation();
			selectVersion(version);
		});
		
		dropdownMenu.appendChild(item);
	});
	
	// 生成各版本内容
	versions.forEach((version) => {
		const versionData = config[version];
		const isLatest = version === latestVersion;
		
		const contentDiv = document.createElement('div');
		contentDiv.id = `content-${version}`;
		contentDiv.className = `download-content ${version === currentVersion ? 'active' : ''}`;
		
		// 版本信息
		const description = getVersionDescription(version);
		const releaseDate = versionData.releaseDate;
		
		let latestBadgeHtml = '';
		if(isLatest){
			latestBadgeHtml = `<span class="version-latest-badge">${tr("latest_badge")}</span>`;
		}
		
		const versionInfo = document.createElement('div');
		versionInfo.className = 'version-info';
		versionInfo.innerHTML = `
			<div class="version-header">
				<div class="version-label-wrapper">
					<span class="version-label">${tr("version_label")} ${version}</span>
					${latestBadgeHtml}
				</div>
				<span class="version-date">${releaseDate}</span>
			</div>
			<div class="version-desc">${description}</div>
		`;
		contentDiv.appendChild(versionInfo);
		
		// 下载列表
		const downloadList = document.createElement('div');
		downloadList.className = 'download-list';
		
		versionData.downloads.forEach(item => {
			const downloadItem = document.createElement('a');
			downloadItem.className = 'download-item';
			
            if (item.system === 'system_macos') {
                downloadItem.href = "javascript:void(0)";
                downloadItem.onclick = (e) => { e.preventDefault(); showMacOsModal(item.link); };
            } else {
                downloadItem.href = item.link;
            }

			downloadItem.target = '_blank';
			
			const typeLabel = item.type ? tr(item.type) : '';
			const variantLabel = item.variant ? tr(item.variant) : '';
			const platformIcon = item.system === 'system_windows' ? icons.windows : (item.system === 'system_macos' ? icons.macos : icons.android);
			const platformAlt = item.system === 'system_windows' ? tr("alt_windows") : (item.system === 'system_macos' ? tr("alt_macos") : tr("alt_android"));
			
			downloadItem.innerHTML = `
				<div class="download-info">
					<div class="platform-icon">
						<img src="${platformIcon}" alt="${platformAlt}" style="filter: ${svgColorFilter.indigoDark};">
					</div>
					<div class="platform-details">
						<span class="platform-name">${tr(item.system)} ${variantLabel}</span>
						<div class="file-meta">
							<span>${tr(item.suffix)}</span>
							${typeLabel ? `<span>${typeLabel}</span>` : ''}
						</div>
					</div>
				</div>
				<div class="download-btn">
					<img src="${icons.download}" alt="${tr("alt_download")}" style="filter: brightness(0) invert(1);">
				</div>
			`;
			
			downloadList.appendChild(downloadItem);
		});
		
		contentDiv.appendChild(downloadList);
		contentsContainer.appendChild(contentDiv);
	});
	
	// 绑定滚动事件
	document.getElementById('scrollableContent').addEventListener('scroll', handleScroll);
	
	// 检查是否需要显示滚动提示
	checkScrollHint();
}



// 切换下拉框显示/隐藏
function toggleDropdown(){
	isDropdownOpen = !isDropdownOpen;
	const trigger = document.getElementById('dropdownTrigger');
	const menu = document.getElementById('dropdownMenu');
	
	if(isDropdownOpen){
		trigger.classList.add('active');
		menu.classList.add('show');
	}else{
		trigger.classList.remove('active');
		menu.classList.remove('show');
	}
}

// 选择版本
function selectVersion(version){
	if(version === currentVersion){
		toggleDropdown();
		return;
	}
	
	currentVersion = version;
	
	// 更新下拉框显示
	document.getElementById('currentVersion').textContent = version;
	
	// 更新下拉菜单选中状态
	document.querySelectorAll('.dropdown-item').forEach(item => {
		item.classList.remove('selected');
		const itemText = item.querySelector('.dropdown-item-text').textContent;
		if (itemText === version) {
			item.classList.add('selected');
		}
	});
	
	// 关闭下拉菜单
	toggleDropdown();
	
	// 切换内容显示
	document.querySelectorAll('.download-content').forEach(content => {
		content.classList.remove('active');
	});
	document.getElementById(`content-${version}`).classList.add('active');
	
	// 滚动到顶部
	document.getElementById('scrollableContent').scrollTop = 0;
	
	// 重新检查滚动提示
	setTimeout(checkScrollHint, 100);
}

// 平滑滚动到底部
function scrollToBottom(){
	const scrollableContent = document.getElementById('scrollableContent');
	const targetScroll = scrollableContent.scrollHeight - scrollableContent.clientHeight;
	
	scrollableContent.scrollTo({
		top: targetScroll,
		behavior: 'smooth'
	});
}

// 处理滚动事件
function handleScroll(){
	checkScrollHint();
}

// 检查是否需要显示滚动提示
function checkScrollHint(){
	const scrollableContent = document.getElementById('scrollableContent');
	const scrollHint = document.getElementById('scrollHint');
	
	const isScrollable = scrollableContent.scrollHeight > scrollableContent.clientHeight;
	const isScrolledToBottom = scrollableContent.scrollTop + scrollableContent.clientHeight >= scrollableContent.scrollHeight - 10;
	
	if(!isScrollable || isScrolledToBottom){
		scrollHint.classList.add('hidden');
	}else{
		scrollHint.classList.remove('hidden');
	}
}

// 点击外部关闭下拉菜单
document.addEventListener('click', (e) => {
	const dropdownContainer = document.querySelector('.dropdown-container');
	if (!dropdownContainer.contains(e.target) && isDropdownOpen) {
		toggleDropdown();
	}
});


function showMacOsModal(link) {
	window.location.href = link;
	document.getElementById('macOsModalTitle').innerText = tr('macos_gatekeeper_title');
	document.getElementById('macOsModalDesc').innerHTML = tr('macos_gatekeeper_desc');
	document.getElementById('macOsModalConfirm').innerText = tr('macos_gatekeeper_confirm');
	document.getElementById('macOsModal').classList.add('active');
}
document.addEventListener('DOMContentLoaded', () => {
	document.getElementById('macOsModalConfirm').addEventListener('click', () => {
		document.getElementById('macOsModal').classList.remove('active');
	});
});

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', init);
	
