// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

struct WorldClockFeatureStrings {
    let title: String
    let hubDescription: String
    let panelDescription: String
    let local: String
    let now: String
    let addPlaceholder: String
    let noMatches: String
    let today: String
    let tomorrow: String
    let yesterday: String
    let showInMenuBar: String
    let hideFromMenuBar: String
    let menuBarLimit: String
    let remove: String
    let showLabels: String
    let timelineHelp: String
    let reverseDrag: String
    let labelHelp: String
    let workingHours: String
    let workingHoursTo: String
    let dayBarsHeading: String
    let menuBarHeading: String
}

extension FeatureStrings {
    static func worldClock(_ language: AppLanguage) -> WorldClockFeatureStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .tr: return .tr
        case .ru: return .ru
        case .es: return .es
        case .sk: return .sk
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ja: return .ja
        case .ko: return .ko
        case .uk: return .uk
        case .zhHans: return .zhHans
        case .zhHK: return .zhHK
        case .zhTW: return .zhTW
        }
    }
}

private extension WorldClockFeatureStrings {
    static let enUS = WorldClockFeatureStrings(
        title: "World Clock",
        hubDescription: "Show other time zones in the menu bar and look ahead across them",
        panelDescription: "Your time zones and a timeline to look ahead",
        local: "Local",
        now: "Now",
        addPlaceholder: "Add a city…",
        noMatches: "No matching time zone",
        today: "Today",
        tomorrow: "Tomorrow",
        yesterday: "Yesterday",
        showInMenuBar: "Show in menu bar",
        hideFromMenuBar: "Remove from menu bar",
        menuBarLimit: "Up to two time zones",
        remove: "Remove",
        showLabels: "Show city labels",
        timelineHelp: "Drag the timeline to see another time in every city",
        reverseDrag: "Reverse drag direction",
        labelHelp: "Your label for this city: text, an emoji or both",
        workingHours: "Working hours",
        workingHoursTo: "to",
        dayBarsHeading: "Day bars",
        menuBarHeading: "Menu bar"
    )

    static let ptBR = WorldClockFeatureStrings(
        title: "Relógio mundial",
        hubDescription: "Mostrar outros fusos horários na barra de menus e ver horários futuros",
        panelDescription: "Seus fusos horários e uma linha do tempo para ver adiante",
        local: "Local",
        now: "Agora",
        addPlaceholder: "Adicionar cidade…",
        noMatches: "Nenhum fuso horário encontrado",
        today: "Hoje",
        tomorrow: "Amanhã",
        yesterday: "Ontem",
        showInMenuBar: "Mostrar na barra de menus",
        hideFromMenuBar: "Remover da barra de menus",
        menuBarLimit: "Até dois fusos horários",
        remove: "Remover",
        showLabels: "Mostrar nomes das cidades",
        timelineHelp: "Arraste a linha do tempo para ver outro horário em cada cidade",
        reverseDrag: "Inverter direção de arrastar",
        labelHelp: "Seu rótulo para esta cidade: texto, um emoji ou ambos",
        workingHours: "Horário de trabalho",
        workingHoursTo: "até",
        dayBarsHeading: "Barras do dia",
        menuBarHeading: "Barra de menus"
    )

    static let tr = WorldClockFeatureStrings(
        title: "Dünya Saati",
        hubDescription: "Diğer saat dilimlerini menü çubuğunda göster ve ileriye bak",
        panelDescription: "Saat dilimlerin ve ileriye bakmak için bir zaman çizelgesi",
        local: "Yerel",
        now: "Şimdi",
        addPlaceholder: "Şehir ekle…",
        noMatches: "Eşleşen saat dilimi yok",
        today: "Bugün",
        tomorrow: "Yarın",
        yesterday: "Dün",
        showInMenuBar: "Menü çubuğunda göster",
        hideFromMenuBar: "Menü çubuğundan kaldır",
        menuBarLimit: "En fazla iki saat dilimi",
        remove: "Kaldır",
        showLabels: "Şehir etiketlerini göster",
        timelineHelp: "Her şehirde başka bir saati görmek için zaman çizelgesini sürükle",
        reverseDrag: "Sürükleme yönünü ters çevir",
        labelHelp: "Bu şehir için etiketin: metin, emoji ya da ikisi",
        workingHours: "Çalışma saatleri",
        workingHoursTo: "–",
        dayBarsHeading: "Gün çubukları",
        menuBarHeading: "Menü çubuğu"
    )

    static let ru = WorldClockFeatureStrings(
        title: "Мировые часы",
        hubDescription: "Показывать другие часовые пояса в строке меню и заглядывать вперёд",
        panelDescription: "Ваши часовые пояса и шкала времени, чтобы заглянуть вперёд",
        local: "Местное",
        now: "Сейчас",
        addPlaceholder: "Добавить город…",
        noMatches: "Часовой пояс не найден",
        today: "Сегодня",
        tomorrow: "Завтра",
        yesterday: "Вчера",
        showInMenuBar: "Показывать в строке меню",
        hideFromMenuBar: "Убрать из строки меню",
        menuBarLimit: "До двух часовых поясов",
        remove: "Удалить",
        showLabels: "Показывать названия городов",
        timelineHelp: "Перетащите шкалу, чтобы увидеть другое время во всех городах",
        reverseDrag: "Обратное направление перетаскивания",
        labelHelp: "Ваша метка для города: текст, эмодзи или оба",
        workingHours: "Рабочие часы",
        workingHoursTo: "–",
        dayBarsHeading: "Шкалы дня",
        menuBarHeading: "Строка меню"
    )

    static let es = WorldClockFeatureStrings(
        title: "Reloj mundial",
        hubDescription: "Muestra otras zonas horarias en la barra de menús y mira hacia adelante",
        panelDescription: "Tus zonas horarias y una línea de tiempo para mirar adelante",
        local: "Local",
        now: "Ahora",
        addPlaceholder: "Añadir ciudad…",
        noMatches: "Ninguna zona horaria coincide",
        today: "Hoy",
        tomorrow: "Mañana",
        yesterday: "Ayer",
        showInMenuBar: "Mostrar en la barra de menús",
        hideFromMenuBar: "Quitar de la barra de menús",
        menuBarLimit: "Hasta dos zonas horarias",
        remove: "Eliminar",
        showLabels: "Mostrar nombres de ciudades",
        timelineHelp: "Arrastra la línea de tiempo para ver otra hora en cada ciudad",
        reverseDrag: "Invertir dirección de arrastre",
        labelHelp: "Tu etiqueta para esta ciudad: texto, un emoji o ambos",
        workingHours: "Horario laboral",
        workingHoursTo: "a",
        dayBarsHeading: "Barras del día",
        menuBarHeading: "Barra de menús"
    )

    static let sk = WorldClockFeatureStrings(
        title: "Svetový čas",
        hubDescription: "Zobraziť ďalšie časové pásma na lište ponuky a pozrieť sa dopredu",
        panelDescription: "Vaše časové pásma a časová os na pohľad dopredu",
        local: "Miestny",
        now: "Teraz",
        addPlaceholder: "Pridať mesto…",
        noMatches: "Žiadne zodpovedajúce časové pásmo",
        today: "Dnes",
        tomorrow: "Zajtra",
        yesterday: "Včera",
        showInMenuBar: "Zobraziť na lište ponuky",
        hideFromMenuBar: "Odstrániť z lišty ponuky",
        menuBarLimit: "Najviac dve časové pásma",
        remove: "Odstrániť",
        showLabels: "Zobraziť názvy miest",
        timelineHelp: "Potiahnutím časovej osi zobrazíte iný čas vo všetkých mestách",
        reverseDrag: "Obrátiť smer ťahania",
        labelHelp: "Váš štítok pre toto mesto: text, emoji alebo oboje",
        workingHours: "Pracovný čas",
        workingHoursTo: "–",
        dayBarsHeading: "Pruhy dňa",
        menuBarHeading: "Lišta ponuky"
    )

    static let de = WorldClockFeatureStrings(
        title: "Weltuhr",
        hubDescription: "Weitere Zeitzonen in der Menüleiste zeigen und vorausschauen",
        panelDescription: "Deine Zeitzonen und eine Zeitleiste zum Vorausschauen",
        local: "Lokal",
        now: "Jetzt",
        addPlaceholder: "Stadt hinzufügen …",
        noMatches: "Keine passende Zeitzone",
        today: "Heute",
        tomorrow: "Morgen",
        yesterday: "Gestern",
        showInMenuBar: "In der Menüleiste zeigen",
        hideFromMenuBar: "Aus der Menüleiste entfernen",
        menuBarLimit: "Bis zu zwei Zeitzonen",
        remove: "Entfernen",
        showLabels: "Städtenamen zeigen",
        timelineHelp: "Zieh die Zeitleiste, um eine andere Uhrzeit in jeder Stadt zu sehen",
        reverseDrag: "Ziehrichtung umkehren",
        labelHelp: "Dein Label für diese Stadt: Text, Emoji oder beides",
        workingHours: "Arbeitszeit",
        workingHoursTo: "bis",
        dayBarsHeading: "Tagesbalken",
        menuBarHeading: "Menüleiste"
    )

    static let fr = WorldClockFeatureStrings(
        title: "Horloge mondiale",
        hubDescription: "Afficher d’autres fuseaux horaires dans la barre des menus et voir plus loin",
        panelDescription: "Vos fuseaux horaires et une frise pour voir plus loin",
        local: "Local",
        now: "Maintenant",
        addPlaceholder: "Ajouter une ville…",
        noMatches: "Aucun fuseau horaire correspondant",
        today: "Aujourd’hui",
        tomorrow: "Demain",
        yesterday: "Hier",
        showInMenuBar: "Afficher dans la barre des menus",
        hideFromMenuBar: "Retirer de la barre des menus",
        menuBarLimit: "Jusqu’à deux fuseaux horaires",
        remove: "Supprimer",
        showLabels: "Afficher le nom des villes",
        timelineHelp: "Faites glisser la frise pour voir une autre heure dans chaque ville",
        reverseDrag: "Inverser le sens du glissement",
        labelHelp: "Votre libellé pour cette ville\u{00A0}: texte, emoji ou les deux",
        workingHours: "Heures de travail",
        workingHoursTo: "à",
        dayBarsHeading: "Barres du jour",
        menuBarHeading: "Barre des menus"
    )

    static let it = WorldClockFeatureStrings(
        title: "Orologio mondiale",
        hubDescription: "Mostra altri fusi orari nella barra dei menu e guarda avanti",
        panelDescription: "I tuoi fusi orari e una linea del tempo per guardare avanti",
        local: "Locale",
        now: "Adesso",
        addPlaceholder: "Aggiungi città…",
        noMatches: "Nessun fuso orario corrispondente",
        today: "Oggi",
        tomorrow: "Domani",
        yesterday: "Ieri",
        showInMenuBar: "Mostra nella barra dei menu",
        hideFromMenuBar: "Rimuovi dalla barra dei menu",
        menuBarLimit: "Fino a due fusi orari",
        remove: "Rimuovi",
        showLabels: "Mostra i nomi delle città",
        timelineHelp: "Trascina la linea del tempo per vedere un altro orario in ogni città",
        reverseDrag: "Inverti direzione di trascinamento",
        labelHelp: "La tua etichetta per questa città: testo, emoji o entrambi",
        workingHours: "Orario di lavoro",
        workingHoursTo: "–",
        dayBarsHeading: "Barre del giorno",
        menuBarHeading: "Barra dei menu"
    )

    static let ja = WorldClockFeatureStrings(
        title: "世界時計",
        hubDescription: "ほかのタイムゾーンをメニューバーに表示し、先の時刻を確認",
        panelDescription: "タイムゾーンの一覧と先の時刻を見るタイムライン",
        local: "ローカル",
        now: "現在",
        addPlaceholder: "都市を追加…",
        noMatches: "一致するタイムゾーンがありません",
        today: "今日",
        tomorrow: "明日",
        yesterday: "昨日",
        showInMenuBar: "メニューバーに表示",
        hideFromMenuBar: "メニューバーから削除",
        menuBarLimit: "最大2つのタイムゾーン",
        remove: "削除",
        showLabels: "都市名を表示",
        timelineHelp: "タイムラインをドラッグすると各都市の別の時刻を確認できます",
        reverseDrag: "ドラッグの方向を反転",
        labelHelp: "この都市のラベル：文字、絵文字、またはその両方",
        workingHours: "勤務時間",
        workingHoursTo: "〜",
        dayBarsHeading: "1日のバー",
        menuBarHeading: "メニューバー"
    )

    static let ko = WorldClockFeatureStrings(
        title: "세계 시계",
        hubDescription: "다른 시간대를 메뉴 막대에 표시하고 앞으로의 시간을 확인",
        panelDescription: "내 시간대 목록과 앞을 내다보는 타임라인",
        local: "현지",
        now: "지금",
        addPlaceholder: "도시 추가…",
        noMatches: "일치하는 시간대가 없음",
        today: "오늘",
        tomorrow: "내일",
        yesterday: "어제",
        showInMenuBar: "메뉴 막대에 표시",
        hideFromMenuBar: "메뉴 막대에서 제거",
        menuBarLimit: "최대 두 개의 시간대",
        remove: "제거",
        showLabels: "도시 이름 표시",
        timelineHelp: "타임라인을 드래그하면 모든 도시의 다른 시간을 볼 수 있습니다",
        reverseDrag: "드래그 방향 반전",
        labelHelp: "이 도시의 레이블: 텍스트, 이모지 또는 둘 다",
        workingHours: "근무 시간",
        workingHoursTo: "~",
        dayBarsHeading: "하루 막대",
        menuBarHeading: "메뉴 막대"
    )

    static let uk = WorldClockFeatureStrings(
        title: "Світовий час",
        hubDescription: "Показувати інші часові пояси в рядку меню й зазирати наперед",
        panelDescription: "Ваші часові пояси та шкала часу, щоб зазирнути наперед",
        local: "Місцевий",
        now: "Зараз",
        addPlaceholder: "Додати місто…",
        noMatches: "Часовий пояс не знайдено",
        today: "Сьогодні",
        tomorrow: "Завтра",
        yesterday: "Учора",
        showInMenuBar: "Показувати в рядку меню",
        hideFromMenuBar: "Прибрати з рядка меню",
        menuBarLimit: "До двох часових поясів",
        remove: "Видалити",
        showLabels: "Показувати назви міст",
        timelineHelp: "Перетягніть шкалу, щоб побачити інший час у кожному місті",
        reverseDrag: "Обернений напрямок перетягування",
        labelHelp: "Ваша мітка для міста: текст, емодзі або обидва",
        workingHours: "Робочі години",
        workingHoursTo: "–",
        dayBarsHeading: "Шкали дня",
        menuBarHeading: "Рядок меню"
    )

    static let zhHans = WorldClockFeatureStrings(
        title: "世界时钟",
        hubDescription: "在菜单栏显示其他时区，并查看未来的时间",
        panelDescription: "你的时区列表和用于查看未来时间的时间轴",
        local: "本地",
        now: "现在",
        addPlaceholder: "添加城市…",
        noMatches: "没有匹配的时区",
        today: "今天",
        tomorrow: "明天",
        yesterday: "昨天",
        showInMenuBar: "在菜单栏中显示",
        hideFromMenuBar: "从菜单栏中移除",
        menuBarLimit: "最多两个时区",
        remove: "移除",
        showLabels: "显示城市名称",
        timelineHelp: "拖动时间轴即可查看每个城市的其他时间",
        reverseDrag: "反转拖动方向",
        labelHelp: "此城市的标签：文字、表情符号或两者",
        workingHours: "工作时间",
        workingHoursTo: "至",
        dayBarsHeading: "一天进度条",
        menuBarHeading: "菜单栏"
    )

    static let zhHK = WorldClockFeatureStrings(
        title: "世界時鐘",
        hubDescription: "在選單列顯示其他時區，並查看未來的時間",
        panelDescription: "你的時區列表及用於查看未來時間的時間軸",
        local: "本地",
        now: "現在",
        addPlaceholder: "加入城市…",
        noMatches: "沒有相符的時區",
        today: "今日",
        tomorrow: "明日",
        yesterday: "昨日",
        showInMenuBar: "在選單列顯示",
        hideFromMenuBar: "從選單列移除",
        menuBarLimit: "最多兩個時區",
        remove: "移除",
        showLabels: "顯示城市名稱",
        timelineHelp: "拖移時間軸即可查看每個城市的其他時間",
        reverseDrag: "反轉拖移方向",
        labelHelp: "此城市的標籤：文字、表情符號或兩者",
        workingHours: "工作時間",
        workingHoursTo: "至",
        dayBarsHeading: "一天進度條",
        menuBarHeading: "選單列"
    )

    static let zhTW = WorldClockFeatureStrings(
        title: "世界時鐘",
        hubDescription: "在選單列顯示其他時區，並查看未來的時間",
        panelDescription: "你的時區列表與用來查看未來時間的時間軸",
        local: "本地",
        now: "現在",
        addPlaceholder: "加入城市…",
        noMatches: "沒有符合的時區",
        today: "今天",
        tomorrow: "明天",
        yesterday: "昨天",
        showInMenuBar: "在選單列中顯示",
        hideFromMenuBar: "從選單列中移除",
        menuBarLimit: "最多兩個時區",
        remove: "移除",
        showLabels: "顯示城市名稱",
        timelineHelp: "拖移時間軸即可查看每個城市的其他時間",
        reverseDrag: "反轉拖移方向",
        labelHelp: "此城市的標籤：文字、表情符號或兩者",
        workingHours: "工作時間",
        workingHoursTo: "至",
        dayBarsHeading: "一天進度條",
        menuBarHeading: "選單列"
    )
}
