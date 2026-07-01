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

function toggleLangDropdown(e) {
	e.stopPropagation();
	const trigger = document.getElementById('lang-dropdown-trigger');
	const menu = document.querySelector('.lang-dropdown-menu');
	trigger.classList.toggle('active');
	menu.classList.toggle('show');
}

function toggleMobileNav() {
	const drawer = document.getElementById('mobile-drawer');
	drawer.classList.toggle('open');
}

const fallbackLang = {
	latest_badge: {
		zh: '最新版',
		'th': 'ล่าสุด',
		'en': 'Latest',
		ja: '最新',
		ko: '최신',
		fr: 'Dernier',
		de: 'Aktuell',
		es: 'Último',
		it: 'Ultimo',
		pt: 'Mais recente',
		id: 'Terbaru',
		'tw': '最新版'
	},
	version_label: {
		zh: '版本',
		'tw': '版本',
		'en': 'Version',
		ja: 'バージョン',
		ko: '버전',
		fr: 'Version',
		de: 'Version',
		es: 'Versión',
		it: 'Versione',
		pt: 'Versão',
		id: 'Versi',
		th: 'เวอร์ชัน'
	},
	system_macos: { zh: 'macOS', 'tw': 'macOS', en: 'macOS', ja: 'macOS', ko: 'macOS', fr: 'macOS', de: 'macOS', es: 'macOS', it: 'macOS', pt: 'macOS', id: 'macOS', th: 'macOS' },
	system_windows: { zh: 'Windows', 'tw': 'Windows', en: 'Windows', ja: 'Windows', ko: 'Windows', fr: 'Windows', de: 'Windows', es: 'Windows', it: 'Windows', pt: 'Windows', id: 'Windows', th: 'Windows' },
	system_android: { zh: 'Android', 'tw': 'Android', en: 'Android', ja: 'Android', ko: 'Android', fr: 'Android', de: 'Android', es: 'Android', it: 'Android', pt: 'Android', id: 'Android', th: 'Android' },
	alt_macos: { zh: 'macOS', 'tw': 'macOS', en: 'macOS', ja: 'macOS', ko: 'macOS', fr: 'macOS', de: 'macOS', es: 'macOS', it: 'macOS', pt: 'macOS', id: 'macOS', th: 'macOS' },
	alt_windows: { zh: 'Windows', 'tw': 'Windows', en: 'Windows', ja: 'Windows', ko: 'Windows', fr: 'Windows', de: 'Windows', es: 'Windows', it: 'Windows', pt: 'Windows', id: 'Windows', th: 'Windows' },
	alt_android: { zh: 'Android', 'tw': 'Android', en: 'Android', ja: 'Android', ko: 'Android', fr: 'Android', de: 'Android', es: 'Android', it: 'Android', pt: 'Android', id: 'Android', th: 'Android' },
	alt_download: { zh: '下载', 'tw': '下載', en: 'Download', ja: 'ダウンロード', ko: '다운로드', fr: 'Téléchargement', de: 'Herunterladen', es: 'Descargar', it: 'Scarica', pt: 'Baixar', id: 'Unduh', th: 'ดาวน์โหลด' },
	suffix_zip: { zh: '.zip', 'tw': '.zip', en: '.zip', ja: '.zip', ko: '.zip', fr: '.zip', de: '.zip', es: '.zip', it: '.zip', pt: '.zip', id: '.zip', th: '.zip' },
	suffix_exe: { zh: '.exe', 'tw': '.exe', en: '.exe', ja: '.exe', ko: '.exe', fr: '.exe', de: '.exe', es: '.exe', it: '.exe', pt: '.exe', id: '.exe', th: '.exe' },
	type_1: { zh: '单文件绿色版', 'tw': '單文件綠色版', en: 'Single-file Portable', ja: '単一ファイルポータブル版', ko: '단일 파일 포터블', fr: 'Portable à fichier unique', de: 'Einzeldatei-Portable', es: 'Portátil de un solo archivo', it: 'Portabile a file singolo', pt: 'Portátil de arquivo único', id: 'Portabel File Tunggal', th: 'เวอร์ชันพกพาไฟล์เดียว' },
	type_2: { zh: '便携绿色版', 'tw': '攜帶綠色版', en: 'Portable Edition', ja: 'ポータブル版', ko: '포터블 에디션', fr: 'Édition Portable', de: 'Portable Edition', es: 'Edición Portátil', it: 'Edizione Portabile', pt: 'Edição Portátil', id: 'Edisi Portabel', th: 'เวอร์ชันพกพา' },
	macos_gatekeeper_title: { zh: '首次运行 macOS 版的重要提示', 'tw': '首次運行 macOS 版的重要提示', en: 'Important Note for macOS Users', ja: 'macOS版の初回実行に関する重要なお知らせ', ko: 'macOS 버전 최초 실행 시 중요 안내', fr: 'Note importante pour les utilisateurs macOS', de: 'Wichtiger Hinweis für macOS-Benutzer', es: 'Nota importante para usuarios de macOS', it: 'Nota importante per gli utenti macOS', pt: 'Nota importante para usuários do macOS', id: 'Pemberitahuan Penting untuk Pengguna macOS', th: 'คำแนะนำที่สำคัญสำหรับการเรียกใช้งาน macOS เป็นครั้งแรก' },
	macos_gatekeeper_desc: { zh: '由于当前程序是免签名的便携版，首次打开可能会被系统拦截。<br><br>请按照以下步骤正常打开：<br>1. 若弹出“Apple 无法检查 App 是否包含恶意软件”，请点按 <b>好</b>。<br>2. 打开系统的 <b>系统设置</b> > <b>隐私与安全性</b>。<br>3. 前往“安全性”部分，找到关于 Nikki Albums 的提示，然后点按 <b>打开</b>。<br>4. 点按 <b>仍要打开</b>，输入你的登录密码，然后点按 <b>好</b>。', 'tw': '由於當前程序是免簽名的攜帶版，首次打開可能會被系統攔截。<br><br>請按照以下步驟正常打開：<br>1. 若彈出“Apple 無法檢查 App 是否包含惡意軟件”，請點按 <b>好</b>。<br>2. 打開系統的 <b>系統設置</b> > <b>隱私與安全性</b>。<br>3. 前往“安全性”部分，找到關於 Nikki Albums 的提示，然後點按 <b>打開</b>。<br>4. 點按 <b>仍要打開</b>，輸入你的登錄密碼，然後點按 <b>好</b>。', en: 'Since this is an ad-hoc signed app, macOS Gatekeeper might block it on the first run.<br><br>Please follow these steps to open it normally:<br>1. If a dialog says "Apple can\'t check app for malicious software", click <b>OK</b>.<br>2. Open <b>System Settings</b> > <b>Privacy & Security</b>.<br>3. Under the "Security" section, locate Nikki Albums and click <b>Open</b>.<br>4. Click <b>Open Anyway</b>, enter your login password, and click <b>OK</b>.', ja: '署名なしのポータブル版であるため、初回起動時にmacOSによってブロックされる場合があります。<br><br>以下の手順に従って正常に開いてください：<br>1. 「Appleは悪質なソフトウェアがないか確認できません」と表示された場合は、<b>OK</b>をクリックします。<br>2. <b>システム設定</b> > <b>プライバシーとセキュリティ</b>を開きます。<br>3. セキュリティ欄にあるNikki Albumsの起動に関するメッセージを確認し、<b>このまま開く</b>をクリックします。<br>4. ログインパスワードを入力し、<b>OK</b>をクリックします。', ko: '본 앱은 서명되지 않은 포터블 버전으로, 최초 실행 시 시스템에 의해 차단될 수 있습니다.<br><br>정상적으로 실행하려면 다음 단계를 따르십시오:<br>1. "Apple에서 악성 소프트웨어가 있는지 확인할 수 없습니다"라는 팝업이 뜨면 <b>확인</b>을 클릭합니다.<br>2. 시스템의 <b>설정</b> > <b>개인정보 보호 및 보안</b>을 엽니다.<br>3. 보안 섹션에서 Nikki Albums 관련 안내를 찾아 <b>열기</b>를 클릭합니다.<br>4. <b>계속 열기</b>를 클릭하고 컴퓨터 암호를 입력한 뒤 <b>확인</b>을 클릭합니다.', fr: 'Puisqu\'il s\'agit d\'une application portable signée ad-hoc, macOS Gatekeeper peut la bloquer lors du premier lancement.<br><br>Veuillez suivre ces étapes pour l\'ouvrir normalement :<br>1. Si une boîte de dialogue indique "Apple ne peut pas vérifier si l\'application contient des logiciels malveillants", cliquez sur <b>OK</b>.<br>2. Ouvrez <b>Réglages Système</b> > <b>Confidentialité et sécurité</b>.<br>3. Dans la section "Sécurité", localisez l\'avis Nikki Albums et cliquez sur <b>Ouvrir quand même</b>.<br>4. Entrez votre mot de passe et validez.', de: 'Da es sich um eine nicht signierte portable Anwendung handelt, blockiert macOS Gatekeeper sie möglicherweise beim ersten Start.<br><br>Bitte befolgen Sie diese Schritte, um sie normal zu öffnen:<br>1. Wenn ein Dialogfeld meldet, dass Apple die App nicht auf Schadsoftware überprüfen kann, klicken Sie auf <b>OK</b>.<br>2. Öffnen Sie die <b>Systemeinstellungen</b> > <b>Datenschutz & Sicherheit</b>.<br>3. Suchen Sie im Bereich „Sicherheit“ nach dem Hinweis zu Nikki Albums und klicken Sie auf <b>Dennoch öffnen</b>.<br>4. Geben Sie Ihr Passwort ein und bestätigen Sie.', es: 'Como es una aplicación portátil sin firmar, macOS Gatekeeper podría bloquearla en el primer inicio.<br><br>Sigue estos pasos para abrirla normalmente:<br>1. Si aparece un diálogo que dice "Apple no puede comprobar si la aplicación contiene software malicioso", haz clic en <b>OK</b>.<br>2. Abre <b>Ajustes del Sistema</b> > <b>Privacidad y seguridad</b>.<br>3. En la sección "Seguridad", busca el aviso sobre Nikki Albums y haz clic en <b>Abrir de todos modos</b>.<br>4. Introduce tu contraseña y confirma.', it: 'Trattandosi di un\'applicazione portabile non firmata, macOS Gatekeeper potrebbe bloccarla al primo avvio.<br><br>Segui questi passaggi per aprirla normalmente:<br>1. Se compare un avviso che dice "Apple non può verificare la presenza di malware", fai clic su <b>OK</b>.<br>2. Apri <b>Impostazioni di Sistema</b> > <b>Privacy e sicurezza</b>.<br>3. Nella sezione "Sicurezza", individua l\'avviso su Nikki Albums e fai clic su <b>Apri comunque</b>.<br>4. Inserisci la tua password e conferma.', pt: 'Como este é um aplicativo portátil sem assinatura oficial, o macOS Gatekeeper pode bloqueá-lo na primeira execução.<br><br>Siga estas etapas para abri-lo normalmente:<br>1. Se um aviso disser que a Apple não pode verificar se há malware, clique em <b>OK</b>.<br>2. Abra <b>Ajustes do Sistema</b> > <b>Privacidade e Segurança</b>.<br>3. Na seção "Segurança", localize a mensagem sobre o Nikki Albums e clique em <b>Abrir Mesmo Assim</b>.<br>4. Digite a sua senha e confirme.', id: 'Karena ini adalah aplikasi portabel yang tidak ditandatangani secara resmi, macOS Gatekeeper mungkin memblokirnya pada peluncuran pertama.<br><br>Silakan ikuti langkah-langkah berikut untuk membukanya secara normal:<br>1. Jika muncul dialog "Apple tidak dapat memeriksa apakah aplikasi mengandung malware", klik <b>OK</b>.<br>2. Buka <b>Pengaturan Sistem</b> > <b>Privasi & Keamanan</b>.<br>3. Di bawah bagian "Keamanan", cari pesan tentang Nikki Albums lalu klik <b>Tetap Buka</b>.<br>4. Masukkan kata sandi komputer Anda lalu konfirmasi.', th: 'เนื่องจากโปรแกรมปัจจุบันเป็นเวอร์ชันพกพาที่ไม่มีการลงนามดิจิทัล ระบบอาจสกัดกั้นการเปิดใช้งานในครั้งแรก<br><br>โปรดปฏิบัติตามขั้นตอนต่อไปนี้เพื่อเปิดตามปกติ:<br>1. หากมีข้อความแจ้งเตือน "Apple ไม่สามารถตรวจสอบแอปเพื่อหาซอฟต์แวร์ที่เป็นอันตรายได้" โปรดคลิก <b>ตกลง</b><br>2. เปิด <b>การตั้งค่าระบบ</b> > <b>ความเป็นส่วนตัวและความปลอดภัย</b><br>3. ไปที่ส่วน "ความปลอดภัย" ค้นหาข้อความแจ้งเตือนเกี่ยวกับ Nikki Albums แล้วคลิก <b>เปิดต่อไป</b><br>4. ป้อนรหัสผ่านการเข้าสู่ระบบของคุณแล้วคลิก <b>ตกลง</b>' },
	macos_gatekeeper_confirm: { zh: '我已了解', 'tw': '我已了解', en: 'Got it', ja: '了解しました', ko: '확인 완료', fr: "J'ai compris", de: 'Verstanden', es: 'Entendido', it: 'Capito', pt: 'Entendido', id: 'Saya mengerti', th: 'ฉันเข้าใจแล้ว' }
};

function getAssetBasePath() {
	const stylesheet = document.querySelector('link[rel="stylesheet"][href*="download.css"]');
	const href = stylesheet ? stylesheet.getAttribute('href') : '';
	const match = href.match(/^(.*)official_website\//);
	return match ? match[1] : './';
}

const icons = {
	windows: `${getAssetBasePath()}official_website/assets/icon/windows.svg`,
	macos: `${getAssetBasePath()}official_website/assets/icon/macos.svg`,
	android: `${getAssetBasePath()}official_website/assets/icon/album.svg`,
	download: `${getAssetBasePath()}official_website/assets/icon/arrow-down.svg`
};

function getPageLanguage() {
	const supported = ['zh', 'zh-tw', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'id', 'th'];
	const pathParts = window.location.pathname.split('/').filter(Boolean);
	const pathLang = pathParts.length > 0 ? pathParts[0] : null;
	if (pathLang && supported.includes(pathLang)) {
		localStorage.setItem('lang', pathLang);
		return pathLang;
	}
	const saved = localStorage.getItem('lang');
	if (saved && supported.includes(saved)) {
		return saved;
	}
	const navLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase();
	if (navLang.startsWith('zh')) {
		return navLang.includes('tw') || navLang.includes('hk') || navLang.includes('hant') ? 'zh-tw' : 'zh';
	}
	if (navLang.startsWith('ja')) return 'ja';
	if (navLang.startsWith('ko')) return 'ko';
	if (navLang.startsWith('fr')) return 'fr';
	if (navLang.startsWith('de')) return 'de';
	if (navLang.startsWith('es')) return 'es';
	if (navLang.startsWith('it')) return 'it';
	if (navLang.startsWith('pt')) return 'pt';
	if (navLang.startsWith('id')) return 'id';
	if (navLang.startsWith('th')) return 'th';
	return 'en';
}

function translate(key) {
	const currentLang = getPageLanguage();
	const catalog = (typeof lang !== 'undefined' && lang && typeof lang === 'object') ? lang : fallbackLang;
	const value = catalog[key];
	if (!value) return key;
	return value[currentLang] || value['zh'] || value['en'] || key;
}

function getLatestVersion() {
	return Object.keys(config)[0];
}

function getVersionDescription(version) {
	const currentLang = getPageLanguage();
	const versionData = config[version];
	if (!versionData || !versionData.description) return '';
	return versionData.description[currentLang] || versionData.description['zh'] || '';
}

function renderVersionList() {
	const menu = document.getElementById('versionMenu');
	if (!menu) return;
	const versions = Object.keys(config);
	const latestVersion = getLatestVersion();
	menu.innerHTML = '';
	versions.forEach((version, index) => {
		const item = document.createElement('li');
		item.className = 'sidebar-item';
		const link = document.createElement('a');
		link.className = `sidebar-link${index === 0 ? ' active' : ''}`;
		link.href = `#version-${version}`;
		link.dataset.version = version;
		link.innerHTML = `<span>${version}</span>${index === 0 ? '<span class="version-pill">'+translate('latest_badge')+'</span>' : ''}`;
		link.addEventListener('click', (event) => {
			event.preventDefault();
			selectVersion(version);
		});
		item.appendChild(link);
		menu.appendChild(item);
	});
	menu.querySelectorAll('.sidebar-link').forEach((link) => {
		link.addEventListener('click', () => {
			document.querySelector('.doc-sidebar').classList.remove('active');
		});
	});
}

function selectVersion(version) {
	const versions = Object.keys(config);
	const latestVersion = getLatestVersion();
	const currentVersion = version;
	const title = document.getElementById('versionTitle');
	const badge = document.getElementById('activeVersionBadge');
	const meta = document.getElementById('versionMeta');
	const notes = document.getElementById('releaseNotes');
	const links = document.getElementById('downloadLinks');

	if (!title || !badge || !meta || !notes || !links) return;

	document.querySelectorAll('.sidebar-link').forEach((link) => {
		link.classList.toggle('active', link.dataset.version === currentVersion);
	});

	title.textContent = `${translate('version_label')} ${currentVersion}`;
	badge.textContent = currentVersion === latestVersion ? translate('latest_badge') : '';
	badge.style.display = currentVersion === latestVersion ? 'inline-flex' : 'none';
	meta.innerHTML = `<span>${config[currentVersion].releaseDate}</span>`;
	notes.innerHTML = `<p>${getVersionDescription(currentVersion).replace(/\n/g, '<br>')}</p>`;
	links.innerHTML = '';
	config[currentVersion].downloads.forEach((item) => {
		const linkEl = document.createElement('a');
		linkEl.className = 'download-item';
		const isMac = item.system === 'system_macos';
		linkEl.href = isMac ? 'javascript:void(0)' : item.link;
		linkEl.target = '_blank';
		linkEl.rel = 'noopener noreferrer';
		if (isMac) {
			linkEl.addEventListener('click', (event) => {
				event.preventDefault();
				showMacOsModal(item.link);
			});
		}
		const typeLabel = item.type ? translate(item.type) : '';
		const variantLabel = item.variant ? translate(item.variant) : '';
		const platformIcon = item.system === 'system_windows' ? icons.windows : (item.system === 'system_macos' ? icons.macos : icons.android);
		const platformAlt = item.system === 'system_windows' ? translate('alt_windows') : (item.system === 'system_macos' ? translate('alt_macos') : translate('alt_android'));
		linkEl.innerHTML = `
			<div class="download-info">
				<div class="platform-icon">
					<img src="${platformIcon}" alt="${platformAlt}">
				</div>
				<div class="platform-details">
					<span class="platform-name">${translate(item.system)} ${variantLabel}</span>
					<div class="file-meta">
						<span>${translate(item.suffix)}</span>
						${typeLabel ? `<span>${typeLabel}</span>` : ''}
					</div>
				</div>
		</div>
		<div class="download-btn">
			<img src="${icons.download}" alt="${translate('alt_download')}">
		</div>`;
		links.appendChild(linkEl);
	});
}

function showMacOsModal(link) {
	const modal = document.getElementById('macOsModal');
	const confirmBtn = document.getElementById('macOsModalConfirm');
	if (!modal || !confirmBtn) {
		window.location.href = link;
		return;
	}
	confirmBtn.dataset.downloadUrl = link;
	document.getElementById('macOsModalTitle').innerText = translate('macos_gatekeeper_title');
	document.getElementById('macOsModalDesc').innerHTML = translate('macos_gatekeeper_desc');
	confirmBtn.innerText = translate('macos_gatekeeper_confirm');
	modal.classList.add('active');
}

document.addEventListener('DOMContentLoaded', () => {
	const themeToggleBtn = document.getElementById('theme-toggle-btn');
	if (themeToggleBtn) {
		themeToggleBtn.addEventListener('click', toggleTheme);
	}

	const langDropdownBtn = document.querySelector('.lang-dropdown-btn');
	const langDropdownMenu = document.querySelector('.lang-dropdown-menu');
	if (langDropdownBtn && langDropdownMenu) {
		langDropdownBtn.addEventListener('click', toggleLangDropdown);
		window.addEventListener('click', () => {
			langDropdownBtn.classList.remove('active');
			langDropdownMenu.classList.remove('show');
		});
	}

	const sidebarToggle = document.getElementById('sidebar-toggle');
	const sidebar = document.querySelector('.doc-sidebar');
	if (sidebarToggle && sidebar) {
		sidebarToggle.addEventListener('click', () => {
			sidebar.classList.toggle('active');
		});
	}

	document.querySelectorAll('#mobile-drawer a').forEach((link) => {
		link.addEventListener('click', () => {
			document.getElementById('mobile-drawer').classList.remove('open');
		});
	});

	const modal = document.getElementById('macOsModal');
	const modalConfirm = document.getElementById('macOsModalConfirm');
	if (modal && modalConfirm) {
		modalConfirm.addEventListener('click', () => {
			const downloadUrl = modalConfirm.dataset.downloadUrl;
			modal.classList.remove('active');
			if (downloadUrl) {
				window.location.href = downloadUrl;
			}
		});
		modal.addEventListener('click', (event) => {
			if (event.target === modal) {
				modal.classList.remove('active');
			}
		});
	}

	renderVersionList();
	selectVersion(getLatestVersion());
});
