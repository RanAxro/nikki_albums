const config = {
	"v3.08.02": {
		"releaseDate": "2026-6-28",
		"description": {
			"de": "1. Problem mit fehlenden Dateien beim Öffnen der App unter Windows behoben",
			"en": "1. Fixed missing file issue when opening the app on Windows",
			"es": "1. Corregido el problema de archivos faltantes al abrir la aplicación en Windows",
			"fr": "1. Correction du problème de fichiers manquants lors de l'ouverture de l'application sous Windows",
			"id": "1. Memperbaiki masalah file yang hilang saat membuka aplikasi di Windows",
			"it": "1. Corretto il problema dei file mancanti all'apertura dell'app su Windows",
			"ja": "1. Windowsでアプリを開いたときにファイルが欠落する問題を修正",
			"ko": "1. Windows에서 앱을 열 때 파일이 누락되는 문제 수정",
			"pt": "1. Corrigido o problema de arquivos ausentes ao abrir o aplicativo no Windows",
			"th": "1. แก้ไขปัญหาไฟล์หายไปเมื่อเปิดแอปใน Windows",
			"zh": "1. 修复Windows上打开应用时文件缺失的问题",
			"tw": "1. 修復Windows上開啟應用程式時檔案缺失的問題"
			// "de": "",
			// "en": "",
			// "es": "",
			// "fr": "",
			// "id": "",
			// "it": "",
			// "ja": "",
			// "ko": "",
			// "pt": "",
			// "th": "",
			// "zh": "",
			// "tw": ""
			
      // "de-DE": "",
      // "en-US": "",
      // "es-ES": "",
      // "fr-FR": "",
      // "id-ID": "",
      // "it-IT": "",
      // "ja-JP": "",
      // "ko-KR": "",
      // "pt-BR": "",
      // "th-TH": "",
      // "zh-CN": "",
      // "zh-TW": ""
		},
		"downloads": [
			{
				"system": "system_macos",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.08.02/Nikki%20Albums-v3.08.02-MacOS-arm64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.08.02/Nikki%20Albums-v3.08.02-Windows-x64.zip"
			}
		]
	},
	"v3.08.01": {
		"releaseDate": "2026-6-18",
		"description": {
			"de": "1. Fehler behoben, bei dem das Spiel auf macOS nicht gefunden werden konnte\n2. Einige falsche Übersetzungen korrigiert",
			"en": "1. Fixed the bug where the game could not be located on macOS\n2. Fixed some incorrect translations",
			"es": "1. Se corrigió el error por el que el juego no se podía localizar en macOS\n2. Se corrigieron algunas traducciones incorrectas",
			"fr": "1. Correction du bug empêchant de localiser le jeu sur macOS\n2. Correction de certaines traductions erronées",
			"id": "1. Memperbaiki bug di mana game tidak dapat ditemukan di macOS\n2. Memperbaiki beberapa terjemahan yang salah",
			"it": "1. Corretto il bug per cui il gioco non poteva essere localizzato su macOS\n2. Corrette alcune traduzioni errate",
			"ja": "1. macOSでゲームが見つからないバグを修正しました\n2. 一部の誤訳を修正しました",
			"ko": "1. macOS에서 게임을 찾을 수 없는 버그를 수정했습니다\n2. 일부 잘못된 번역을 수정했습니다",
			"pt": "1. Corrigido o bug em que o jogo não podia ser localizado no macOS\n2. Corrigidas algumas traduções incorretas",
			"th": "1. แก้ไขบั๊กที่ไม่สามารถค้นหาเกมบน macOS ได้\n2. แก้ไขคำแปลที่ไม่ถูกต้องบางส่วน",
			"zh": "1. 修复了在MacOS上定位不到游戏的bug\n2. 修复部分错误翻译",
			"tw": "1. 修復了在MacOS上定位不到遊戲的bug\n2. 修復部分錯誤翻譯"
		},
		"downloads": [
			{
				"system": "system_macos",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.08.01/Nikki%20Albums-v3.08.01-MacOS-arm64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.08.01/Nikki%20Albums-v3.08.01-Windows-x64.zip"
			}
		]
	},
	"v3.08": {
		"releaseDate": "2026-6-13",
		"description": {
			"de": "- Funktionen\n  1. Unterstützung des Exports von Bildern in einen voreingestellten Ordner, ohne dass jedes Mal ein Zielordner ausgewählt werden muss\n  2. Unterstützung des Exports von Live Photos unter Windows\n  3. Unterstützung von 12 Sprachen hinzugefügt\n  4. Hot-Update-Funktion hinzugefügt – Teilweise Ressourcen-Updates ohne Neuinstallation der Software\n  5. Automatischer Neustart der Software nach einem Update hinzugefügt\n\n- Leistung & Optimierung\n  1. Leistung bei der Umwandlung von \"Dynamic Album\"-Videos in GIF-Animationen optimiert, Geschwindigkeitssteigerung um 95 %\n  2. Beim Laden von Vorschaubildern wird nun bevorzugt auf Bilder niedriger Qualität zurückgegriffen, um die Dekodiergeschwindigkeit zu erhöhen\n  3. Startgeschwindigkeit der Software optimiert\n\n- Bugfixes\n  1. Behoben: Collage wurde nicht dekodiert\n  2. Behoben: Software reagierte beim Start unter Windows nicht\n  3. Behoben: Export auf Netzwerkgeräte unter macOS war nicht verfügbar",
			"en": "- Features\n  1. Support exporting images to a preset folder without selecting the destination folder each time\n  2. Support exporting Live Photos on Windows\n  3. Added multi-language support (12 languages)\n  4. Added hot update functionality – partial resource updates without reinstalling the software\n  5. Added automatic restart after software update\n\n- Performance & Optimization\n  1. Optimized performance for converting \"Dynamic Album\" videos to GIF animations, speed improved by 95%\n  2. Thumbnail loading now prioritizes low-quality images to accelerate decoding speed\n  3. Optimized software startup speed\n\n- Bug Fixes\n  1. Fixed: Collage not decoding\n  2. Fixed: Software unresponsive on launch under Windows\n  3. Fixed: Export to network devices unavailable on macOS",
			"es": "- Funciones\n  1. Soporte para exportar imágenes a una carpeta preestablecida, sin necesidad de seleccionar la carpeta de destino cada vez\n  2. Soporte para exportar Live Photos en Windows\n  3. Se ha añadido soporte multilingüe (12 idiomas)\n  4. Se ha añadido la función de actualización en caliente: actualizaciones parciales de recursos sin reinstalar el software\n  5. Se ha añadido el reinicio automático tras la actualización del software\n\n- Rendimiento y optimización\n  1. Rendimiento optimizado para convertir vídeos de \"Álbum dinámico\" a animaciones GIF, velocidad mejorada un 95 %\n  2. Al cargar miniaturas, se priorizan las imágenes de baja calidad para acelerar la velocidad de decodificación\n  3. Velocidad de inicio del software optimizada\n\n- Corrección de errores\n  1. Corregido: Collage no se decodificaba\n  2. Corregido: El software no respondía al iniciarse en Windows\n  3. Corregido: La exportación a dispositivos de red no estaba disponible en macOS",
			"fr": "- Fonctionnalités\n  1. Prise en charge de l'exportation d'images vers un dossier prédéfini, sans avoir à sélectionner le dossier de destination à chaque fois\n  2. Prise en charge de l'exportation des Live Photos sous Windows\n  3. Ajout de la prise en charge multilingue (12 langues)\n  4. Ajout de la fonction de mise à jour à chaud : mises à jour partielles des ressources sans réinstallation du logiciel\n  5. Ajout du redémarrage automatique après la mise à jour du logiciel\n\n- Performances et optimisation\n  1. Optimisation des performances de conversion des vidéos \"Album dynamique\" en animations GIF, vitesse améliorée de 95 %\n  2. Lors du chargement des vignettes, priorité aux images de faible qualité pour accélérer la vitesse de décodage\n  3. Vitesse de démarrage du logiciel optimisée\n\n- Corrections de bugs\n  1. Corrigé : Collage non décodé\n  2. Corrigé : Le logiciel ne répondait pas au démarrage sous Windows\n  3. Corrigé : L'exportation vers des périphériques réseau était indisponible sur macOS",
			"id": "- Fitur\n  1. Mendukung ekspor gambar ke folder yang telah ditetapkan, tanpa perlu memilih folder tujuan setiap kali\n  2. Mendukung ekspor Live Photo di Windows\n  3. Menambahkan dukungan multi-bahasa (12 bahasa)\n  4. Menambahkan fitur pembaruan panas, pembaruan sumber daya parsial tanpa perlu menginstal ulang perangkat lunak\n  5. Menambahkan fitur restart otomatis setelah memperbarui perangkat lunak\n\n- Kinerja & Optimasi\n  1. Mengoptimalkan kinerja konversi video \"Album Dinamis\" menjadi animasi GIF, kecepatan meningkat 95%\n  2. Saat memuat thumbnail, memprioritaskan gambar berkualitas rendah untuk mempercepat kecepatan decoding\n  3. Mengoptimalkan kecepatan startup perangkat lunak\n\n- Perbaikan Bug\n  1. Memperbaiki: Collage tidak ter-decode\n  2. Memperbaiki: Perangkat lunak tidak responsif saat dijalankan di Windows\n  3. Memperbaiki: Ekspor ke perangkat jaringan tidak tersedia di macOS",
			"it": "- Funzionalità\n  1. Supporto per l'esportazione di immagini in una cartella preimpostata, senza dover selezionare la cartella di destinazione ogni volta\n  2. Supporto per l'esportazione di Live Photo su Windows\n  3. Aggiunto supporto multilingue (12 lingue)\n  4. Aggiunta la funzione di aggiornamento a caldo: aggiornamenti parziali delle risorse senza reinstallare il software\n  5. Aggiunto il riavvio automatico dopo l'aggiornamento del software\n\n- Prestazioni e ottimizzazione\n  1. Ottimizzate le prestazioni nella conversione dei video \"Album dinamico\" in animazioni GIF, velocità migliorata del 95%\n  2. Durante il caricamento delle miniature, priorità alle immagini a bassa qualità per accelerare la velocità di decodifica\n  3. Velocità di avvio del software ottimizzata\n\n- Correzioni di bug\n  1. Corretto: Collage non decodificato\n  2. Corretto: Il software non rispondeva all'avvio su Windows\n  3. Corretto: L'esportazione su dispositivi di rete non era disponibile su macOS",
			"ja": "- 機能\n  1. 画像をあらかじめ設定したフォルダにエクスポートできるようになり、毎回保存先フォルダを選択する必要がなくなりました\n  2. WindowsでLive Photo（ライブフォト）をエクスポートできるようになりました\n  3. 多言語対応を追加しました（12言語）\n  4. ホットアップデート機能を追加しました。一部のリソース更新はソフトウェアの再インストールなしで行えます\n  5. ソフトウェア更新後の自動再起動機能を追加しました\n\n- パフォーマンスと最適化\n  1. 「ダイナミックアルバム」の動画をGIFアニメーションに変換する性能を最適化し、速度が95%向上しました\n  2. サムネイルの読み込み時に低品質の画像を優先的に使用し、デコード速度を高速化しました\n  3. ソフトウェアの起動速度を最適化しました\n\n- バグ修正\n  1. コラージュがデコードされないバグを修正しました\n  2. Windowsでソフトウェアを起動しても反応しないバグを修正しました\n  3. macOSでネットワークデバイスへのエクスポートが利用できないバグを修正しました",
			"ko": "- 기능\n  1. 이미지를 미리 설정된 폴더로 내보내기를 지원하여 매번 내보내기 폴더를 선택할 필요가 없습니다\n  2. Windows에서 라이브 포토(Live Photo) 내보내기를 지원합니다\n  3. 다국어 지원 추가(12개 언어)\n  4. 핫 업데이트 기능 추가, 일부 리소스 업데이트는 소프트웨어 재설치 없이 진행됩니다\n  5. 소프트웨어 업데이트 후 자동 재시작 기능 추가\n\n- 성능 및 최적화\n  1. \"다이나믹 앨범\" 동영상을 GIF 애니메이션으로 변환하는 성능을 최적화하여 속도가 95% 향상되었습니다\n  2. 썸네일 로드 시 저품질 이미지를 우선적으로 사용하여 디코딩 속도를 가속화합니다\n  3. 소프트웨어 시작 속도를 최적화했습니다\n\n- 버그 수정\n  1. 콜라주(collage)가 디코딩되지 않는 버그를 수정했습니다\n  2. Windows에서 소프트웨어를 실행해도 반응이 없는 버그를 수정했습니다\n  3. macOS에서 네트워크 장치로 내보내기가 불가능한 버그를 수정했습니다",
			"pt": "- Funcionalidades\n  1. Suporte à exportação de imagens para uma pasta predefinida, sem a necessidade de selecionar a pasta de destino toda vez\n  2. Suporte à exportação de Live Photos no Windows\n  3. Adicionado suporte multilíngue (12 idiomas)\n  4. Adicionada a função de atualização em tempo real (hot update): atualizações parciais de recursos sem a necessidade de reinstalar o software\n  5. Adicionado reinício automático após a atualização do software\n\n- Desempenho e Otimização\n  1. Desempenho otimizado para conversão de vídeos do \"Álbum Dinâmico\" em animações GIF, velocidade melhorada em 95%\n  2. Ao carregar miniaturas, priorização de imagens de baixa qualidade para acelerar a velocidade de decodificação\n  3. Velocidade de inicialização do software otimizada\n\n- Correções de Bugs\n  1. Corrigido: Collage não sendo decodificado\n  2. Corrigido: Software não respondendo ao iniciar no Windows\n  3. Corrigido: Exportação para dispositivos de rede indisponível no macOS",
			"th": "- ฟีเจอร์\n  1. รองรับการส่งออกรูปภาพไปยังโฟลเดอร์ที่ตั้งค่าไว้ล่วงหน้า โดยไม่ต้องเลือกโฟลเดอร์ปลายทางทุกครั้ง\n  2. รองรับการส่งออก Live Photo บน Windows\n  3. เพิ่มการรองรับหลายภาษา (12 ภาษา)\n  4. เพิ่มฟีเจอร์อัปเดตแบบร้อน (Hot Update) อัปเดตทรัพยากรบางส่วนได้โดยไม่ต้องติดตั้งซอฟต์แวร์ใหม่\n  5. เพิ่มฟีเจอร์รีสตาร์ทอัตโนมัติหลังจากอัปเดตซอฟต์แวร์\n\n- ประสิทธิภาพและการปรับปรุง\n  1. ปรับปรุงประสิทธิภาพการแปลงวิดีโอ \"อัลบั้มไดนามิก\" เป็นอนิเมชัน GIF ความเร็วเพิ่มขึ้น 95%\n  2. เมื่อโหลดภาพตัวอย่าง จะให้ความสำคัญกับภาพคุณภาพต่ำก่อนเพื่อเร่งความเร็วในการถอดรหัส\n  3. ปรับปรุงความเร็วในการเปิดซอฟต์แวร์\n\n- การแก้ไขบั๊ก\n  1. แก้ไข: คอลลาจ (collage) ไม่ถูกถอดรหัส\n  2. แก้ไข: ซอฟต์แวร์ไม่ตอบสนองเมื่อเปิดใช้งานบน Windows\n  3. แก้ไข: การส่งออกไปยังอุปกรณ์เครือข่ายไม่สามารถใช้งานได้บน macOS",
			"zh": "- 功能\n  1. 支持导出图片到预设的文件夹, 无需每次都选择导出文件夹\n  2. 支持在Windows导出 Live Photo 实况图\n  3. 添加多语言支持(12种语言)\n  4. 增加热更新功能, 部分资源更新无需重装软件\n  5. 增加更新软件后自动重启的功能\n\n- 性能与优化\n  1. 优化将\"动态影集\"的视频转换为gif动图的性能, 速度提升95%\n  2. 加载缩略图时优先使用低质量图，加快解码速度\n  3. 优化软件的启动速度\n\n- bug修复\n  1. 修复collage不解码的bug\n  2. 修复Windows上启动软件时无反应的bug\n  3. 修复macos 导出到网络设备不可用bug",
			"tw": "- 功能\n  1. 支援將圖片匯出到預設的資料夾，無需每次都選擇匯出資料夾\n  2. 支援在 Windows 上匯出 Live Photo 實況照片\n  3. 新增多語言支援（12 種語言）\n  4. 新增熱更新功能，部分資源更新無需重新安裝軟體\n  5. 新增更新軟體後自動重新啟動的功能\n\n- 效能與最佳化\n  1. 最佳化將「動態影集」的影片轉換為 GIF 動圖的效能，速度提升 95%\n  2. 載入縮圖時優先使用低品質圖片，加快解碼速度\n  3. 最佳化軟體的啟動速度\n\n- Bug 修復\n  1. 修復 collage 不解碼的 bug\n  2. 修復 Windows 上啟動軟體時無反應的 bug\n  3. 修復 macOS 匯出到網路裝置不可用的 bug"
		},
		"downloads": [
			{
				"system": "system_macos",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.08/Nikki%20Albums-v3.08-MacOS-arm64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.08/Nikki%20Albums.exe"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.08/Nikki%20Albums-v3.08-Windows-x64.zip"
			}
		]
	},
	"v3.07": {
		"releaseDate": "2026-6-1",
		"description": {
			"zh": "1. macos支持\n2. 国际服支持, 自动识别国际服的相册\n3. 实况图转换, 可以将\"动态影集\"转换成实况Motion Photo或Live Photo(仅MacOS)\n4. 性能优化, 筛选功能的性能提升92%\n5. 更多筛选选项, 新增\"已完成的拍摄任务\", \"未完成的拍摄任务\", \"错位摄影\", \"惊险摄影\", \"照片墙\"筛选项\n6. 全参数解码\n7. 乘骑参数解码\n8. 优化参数显示位置, 将不重要的参数移动到尾部\n9. 为常用功能增加快捷键操作\n10. 相册位置缓存，避免刷新, 移动, 删除, 导入操作后页面跳回顶部\n11. 修复windows应用启动时窗口白屏bug\n12. 设置里增加nikkias配置项\n13. 增加主题跟随系统功能\n14. 修复启动应用时语言恒为中文的bug",
			"en": "1. macOS Support\n2. International Server Support, automatically recognizes international server albums\n3. Live Photo Conversion, can convert \"Dynamic Albums\" to Motion Photo or Live Photo (macOS only)\n4. Performance Optimization, filter function performance improved by 92%\n5. More Filter Options, added \"Completed Shooting Tasks\", \"Incomplete Shooting Tasks\", \"Misaligned Photography\", \"Thrilling Photography\", \"Photo Wall\" filters\n6. Full Parameter Decoding\n7. Mount Parameter Decoding\n8. Optimized Parameter Display Position, moved less important parameters to the end\n9. Added Keyboard Shortcuts for Frequently Used Functions\n10. Album Position Cache, prevents page from jumping back to top after refresh, move, delete, or import operations\n11. Fixed white screen bug when launching Windows app\n12. Added nikkias configuration option in settings\n13. Added Theme Follow System feature\n14. Fixed bug where language was always Chinese when launching the app"
		},
		"downloads": [
			{
				"system": "system_macos",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.07/Nikki%20Albums-v3.07-MacOS-arm64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.07/Nikki%20Albums.exe"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.07/Nikki%20Albums-v3.07-Windows-x64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.07/Nikki%20Albums-v3.07-Windows-x64-release.zip"
			}
		]
	},
	"v3.06": {
		"releaseDate": "2026-4-25",
		"description": {
			"zh": "1.新的相册 \"动态影集\"、\"外部视频\" (/X6Game/Video)\n2.支持将视频转换为gif动图",
			"en": "1. New Album \"Video Album\", \"External Video\"\n2. Support the conversion of videos into GIF animations"
		},
		"downloads": [
			{
				"system": "system_macos",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.06/Nikki%20Albums-v3.06-MacOS-arm64.zip"
			},

			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.06/Nikki%20Albums.exe"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.06/Nikki%20Albums-v3.06-Windows-x64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.06/Nikki%20Albums-v3.06-Windows-x64-release.zip"
			}
		]
	},
	"v3.05.02": {
		"releaseDate": "2026-3-27",
		"description": {
			"zh": "修复bug: 导出图片到网络设备失败",
			"en": "Fix bug: Failed to export image to network device"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.05.02/Nikki%20Albums.exe"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.05.02/Nikki%20Albums-v3.05.02-Windows-x64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.05.02/Nikki%20Albums-v3.05.02-Windows-x64-release.zip"
			}
		]
	},
	"v3.05.01": {
		"releaseDate": "2026-3-26",
		"description": {
			"zh": "修复bug: 全选图片会将被过滤的图片选中",
			"en": "Fix bug: Selecting all images will also select the filtered images."
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.05.01/Nikki%20Albums.exe"
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.05.01/Nikki%20Albums-v3.05.01-Windows-x64.zip"
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.05.01/Nikki%20Albums-v3.05.01-Windows-x64-release.zip"
			}
		]
	},
	"v3.05": {
		"releaseDate": "2026-3-26",
		"description": {
			"zh": "1.增加图片裁剪与调色功能\n2.支持筛选日常拍摄任务图片",
			"en": "1. Add image cropping and color adjustment functions\n2. Support filtering of daily shooting task images"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.05/Nikki%20Albums.exe "
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.05/Nikki%20Albums-v3.05-Windows-x64.zip "
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.05/Nikki%20Albums-v3.05-Windows-x64-release.zip "
			}
		]
	},
	"v3.04": {
		"releaseDate": "2026-3-2",
		"description": {
			"zh": "1.新的相册 \"趣拼海报\"、\"趣拼海报原图\"、\"趣拼海报缩略图\"\n2.增加相册解码功能, 支持解码相机参数, 拍摄地点等关键信息\n3.修复导出图片到网络无法下载的问题\n4.修复启动软件卡住的bug\n5.优化部分ui",
			"en": "1. New albums: \"Fun Collage Posters\", \"Fun Collage Posters (Original)\", \"Fun Collage Posters (Thumbnails)\"\n2. Added album decoding feature, supporting extraction of camera parameters, shooting location, and other key metadata\n3. Fixed issue where exported images could not be downloaded from the network\n4. Fixed bug causing software to freeze on startup\n5. Optimized parts of the UI"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.04/Nikki%20Albums.exe "
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.04/Nikki%20Albums-v3.04-Windows-x64.zip "
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.04/Nikki%20Albums-v3.04-Windows-x64-release.zip "
			}
		]
	},
	"v3.03": {
		"releaseDate": "2026-1-30",
		"description": {
			"zh": "1.新的相册 \"花草拓拓拓\"\n2.增加回收站功能\n3.支持一键导出/备份所有图片\n4.将图片导出到互联网时, 下载方可在线预览/下载单张/下载全部\n5.支持下载其他用户分享的图片\n6.支持将图片打包为\"nikkias\"文件, 该打包方式会无损保留您图片的所有信息\n7.修复了一些bug",
			"en": "1. New album: \"Floral Rubbings\"\n2. Added Recycle Bin feature\n3. Added one-click export/backup for all images\n4. When exporting images to the internet, recipients can now preview online, download single images, or download all\n5. Added support for downloading images shared by other users\n6. Added ability to package images as \".nikkias\" files, which preserves all image information losslessly\n7. Fixed several bugs"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.03/Nikki%20Albums.exe "
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.03/Nikki%20Albums-v3.03-Windows-x64.zip "
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.03/Nikki%20Albums-v3.03-Windows-x64-release.zip "
			}
		]
	},
	"v3.02": {
		"releaseDate": "2025-12-21",
		"description": {
			"zh": "1.支持给uid备注\n2.支持将常用的账号添加到快捷栏\n3.增加标记功能，可以给图片打标签\n4.修复了一些bug",
			"en": "1. Added support for adding notes/aliases to UIDs\n2. Added ability to pin frequently used accounts to the quick access bar\n3. Added tagging feature, allowing you to add labels to images\n4. Fixed several bugs"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.02/Nikki%20Albums.exe "
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.02/Nikki%20Albums-v3.02-Windows-x64.zip "
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.02/Nikki%20Albums-v3.02-Windows-x64-release.zip "
			}
		]
	},
	"v3.01": {
		"releaseDate": "2025-12-12",
		"description": {
			"zh": "1.增加了滚动条\n2.支持正序与倒序查看相册\n3.查看大图时可通过快捷键切换上一张或下一张\n4.查看大图时可通过点击图片以切换图片的选中状态\n5.增加了切换窗口最大化的按钮\n6.增加了删除自定义账号功能\n7.增加了检测更新功能",
			"en": "1. Added scrollbars\n2. Added support for viewing albums in ascending or descending order\n3. Added keyboard shortcuts to navigate to previous/next image when viewing full-size images\n4. Added ability to toggle image selection state by clicking on the image when viewing full-size\n5. Added button to toggle window maximization\n6. Added ability to delete custom accounts\n7. Added update checking feature"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.01/Nikki%20Albums.exe "
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.01/Nikki%20Albums-v3.01-Windows-x64.zip "
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.01/Nikki%20Albums-v3.01-Windows-x64-release.zip "
			}
		]
	},
	"v3.0": {
		"releaseDate": "2025-12-06",
		"description": {
			"zh": "1.支持更多相册的查看\n2.删除图片时可以选择是否删除相同的图片\n3.支持导出图片到剪贴板\n4.支持在同一网络内分享图片\n5.支持拖拽导入图片\n6.支持从剪贴板导入图片\n7.相册图片按时间分类\n8.支持中文，英文\n9.支持更改主题\n10.可以查看一些游戏资源",
			"en": "1. Added support for viewing more albums\n2. Added option to choose whether to delete duplicate images when deleting\n3. Added support for exporting images to clipboard\n4. Added support for sharing images within the same network\n5. Added drag-and-drop import for images\n6. Added support for importing images from clipboard\n7. Album images are now categorized by time\n8. Added support for Chinese and English languages\n9. Added support for changing themes\n10. Added ability to view some game resources"
		},
		"downloads": [
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_exe",
				"link": "https://file-nikki.ranaxro.com/app/v3.0/Nikki%20Albums.exe "
			},
			{
				"system": "system_windows",
				"type": "type_1",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.0/Nikki%20Albums-v3.0-Windows-x64.zip "
			},
			{
				"system": "system_windows",
				"type": "type_2",
				"suffix": "suffix_zip",
				"link": "https://file-nikki.ranaxro.com/app/v3.0/Nikki%20Albums-v3.0-Windows-x64-release.zip "
			}
		]
	},
	"v2.0": {
		"releaseDate": "2024-9-27",
		"description": {
			"zh": "",
			"en": ""
		},
		"downloads": []
	},
	"v1.0": {
		"releaseDate": "2025-9-13",
		"description": {
			"zh": "",
			"en": ""
		},
		"downloads": [
			// {
			// 	"system": "system_windows",
			// 	"type": "type_2",
			// 	"suffix": "suffix_exe",
			// 	"link": "https://file-nikki.ranaxro.com/app/v1.2/Nikki%20Albums-v1.2-Windows-x64.exe "
			// },
			// {
			// 	"system": "system_android",
			// 	"suffix": "suffix_apk",
			// 	"link": "https://file-nikki.ranaxro.com/app/v1.2/Nikki%20Albums-v1.2.apk "
			// },
			// {
			// 	"system": "system_android",
			// 	"type": "type_1",
			// 	"suffix": "suffix_apk",
			// 	"link": "https://file-nikki.ranaxro.com/app/v1.2/Nikki%20Albums-v1.2-Lite.apk ",
			// 	"variant": "variant_lite"
			// }
		]
	}
};