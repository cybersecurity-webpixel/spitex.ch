

		
			


var labels = {"bannermessage":"Afin d'optimiser et d'améliorer continuellement notre site Web, nous utilisons des cookies à des fins d'analyse. En continuant à utiliser le site Web, vous acceptez l'utilisation de cookies. ","revisionmessage":"Notre politique de confidentialité a été modifiée depuis votre dernière visite.","privacypolicylinklabel":"Déclaration de confidentialité","buttonnecessary":"Accepter les cookies nécessaires","buttonaccept":"Accepter tous les cookies","buttonsettings":"Réglages","buttondeny":"Refuser","buttonsave":"Enregistrer les paramètres","buttonclose":"Fermer","settingstitle":"Réglages","cookieusagetitle":"Utilisation des cookies","cookieusagedescription":"","necessarytitle":"Cookies techniquement nécessaires","necessarydescription":"Les cookies essentiels permettent des fonctions de base et sont nécessaires au bon fonctionnement du site.","analyticstitle":"Cookies d'analyse et de performance","analyticsdescription":"Nous utilisons des cookies pour mieux comprendre votre comportement d'utilisateur et vous aider dans votre navigation sur notre site Internet. Nous utilisons en outre ces données pour adapter encore mieux le site Internet à vos besoins.","targetingtitle":"Cookies de ciblage et de publicité","targetingdescription":"Contient des cookies de tiers tels que Facebook et LinkedIn.","moreinformationtitle":"Plus d'informations","moreinformationdescription":"Weitere Informationen","iframetitle":"Contenus intégrés de tiers","iframedescription":"Vidéos de Youtube, Vimeo<br />\r\nVeuillez respecter les conditions d'utilisation de \r\n<a href=\"https://www.youtube.com/static?template=terms\" target=\"_blank\">Youtube</a> et \r\n<a href=\"https://vimeo.com/terms\" target=\"_blank\">Vimeo</a>.","googlemaptitle":"Cartes de Google","googlemapdescription":"Veuillez consulter les conditions d'utilisation de <a href=\"https://cloud.google.com/maps-platform/terms\" target=\"_blank\">Google Maps</a>"};


// obtain cookieconsent plugin
var cc = initCookieConsent();

// run plugin with config object
cc.run({
    current_lang: 'de',
    autoclear_cookies: true,                    // default: false
    cookie_name: 'cc_cookie',                   // default: 'cc_cookie'
    cookie_expiration: 365,                     // default: 182
    page_scripts: true,                         // default: false
    force_consent: false,   // default: false

    // auto_language: null,                     // default: null; could also be 'browser' or 'document'
    // autorun: true,                           // default: true
    // delay: 0,                                // default: 0
    // hide_from_bots: false,                   // default: false
    // remove_cookie_tables: false              // default: false
    // cookie_domain: location.hostname,        // default: current domain
    // cookie_path: '/',                        // default: root
    // cookie_same_site: 'Lax',
    // use_rfc_cookie: false,                   // default: false
    // revision: 0,                             // default: 0

    gui_options: {
        consent_modal: {
            layout: 'bar',                    	// box,cloud,bar
            position: 'bottom center',          // bottom,middle,top + left,right,center
            transition: 'slide'                 // zoom,slide
        },
        settings_modal: {
            layout: 'bar',                      // box,bar
            position: 'left',                   // right,left (available only if bar layout selected)
            transition: 'slide'                 // zoom,slide
        }
    },

    onFirstAction: function(){
       	// console.log('onFirstAction fired');
    },

    onAccept: function (cookie) {
        // console.log('onAccept fired!')
    },

    onChange: function (cookie, changed_preferences) {
        // console.log('onChange fired!');

        // If analytics category is disabled => disable google analytics
        if (!cc.allowedCategory('analytics')) {
            typeof gtag === 'function' && gtag('consent', 'update', {
                'analytics_storage': 'denied'
            });
        }
		/*
			WW-10080
			Wir unterscheiden zwischen Videos und Google-Maps
			Änderung im CookieConsent auch an den iframeManager weitergeben
		*/
		if ( changed_preferences.indexOf( 'iframe' ) > -1 ) {
			if ( cc.allowedCategory( 'iframe' ) ) {
				im.acceptService( 'youtube' );
				im.acceptService( 'vimeo' );
			} else {
				im.rejectService( 'youtube' );
				im.rejectService( 'vimeo' );
			}
		}
		if ( changed_preferences.indexOf( 'gmap' ) > -1 ) {
			if ( cc.allowedCategory( 'gmap' ) ) {
				// Falls erlaubt Maps laden ( TimingProblem mit Bereitstellung der loadmap-Funktion )
				var loadmapIntervall = setInterval( function() {
					if ( 'loadmap' in window ) {
						document
							.querySelectorAll( 'div.googlemap' )
							.forEach( ( element ) => {
								loadmap( element );
							});
						clearInterval( loadmapIntervall );
					}
				}, 200 );

			} else {
				im.rejectService( 'gmap' );
				document.querySelectorAll( 'div.googlemap' ).forEach( ( element ) => {
					element.innerHTML = '';
				});
			}
		}
    },

    languages: {
        'de': {
            consent_modal: {
                title: '',
                description: 			labels.bannermessage,
                primary_btn: {
                    text: 				labels.buttonnecessary,
                    role: 				'accept_necessary'     		//'accept_selected' or 'accept_all'
                },
                secondary_btn: {
                    text: 				labels.buttonaccept,
                    role: 				'accept_all'       		//'settings' or 'accept_necessary'
                },
                tertiary_btn: {
                    text: 				labels.buttonsettings,
                    role: 				'settings'       		//'settings' or 'accept_necessary'
                },
                revision_message: 		labels.revisionmessage
            },
            settings_modal: {
                title: 					labels.settingstitle,
                save_settings_btn: 		labels.buttonsave,
                accept_all_btn: 		labels.buttonaccept,

                close_btn_label: 		labels.buttonclose,
                cookie_table_headers: [
                    {col1: 'Name'},
                    {col2: 'Domain'},
                    {col3: 'Expiration'}
                ],
                blocks: [
                    {
                        title: 			labels.cookieusagetitle,
                        description:	labels.cookieusagedescription
                    },
					{
                        title: 			labels.necessarytitle,
                        description: 	labels.necessarydescription,
                        toggle: {
                            value: 		'necessary',
                            enabled: 	true,
                            readonly:	true  					//cookie categories with readonly=true are all treated as "necessary cookies"
                        }
                    },
					{
                        title: 			labels.analyticstitle,
                        description: 	labels.analyticsdescription,
                        toggle: {
                            value: 		'analytics',
                            enabled: 	false,
                            readonly: 	false
                        },
                        cookie_table: []
                    },
					{
                        title: 			labels.targetingtitle,
                        description: 	labels.targetingdescription,
                        toggle: {
                            value: 		'targeting',
                            enabled: 	false,
                            readonly: 	false,
                            reload: 	'on_disable'            // New option in v2.4, check readme.md
                        },
                        cookie_table: []
                    },
					{
						title: 			labels.iframetitle,
						description: 	labels.iframedescription,
						toggle: 		{
							value: 		'iframe',
							enabled: 	false,
							readonly: 	false
						},
						cookie_table: []
					},
					{
						title: 			labels.googlemaptitle,
						description: 	labels.googlemapdescription,
						toggle: 		{
							value: 		'gmap',
							enabled: 	false,
							readonly: 	false,
							cookie_table: []
						}
					}
                ]
            }
        }
    }
});

if ( cc.allowedCategory( 'gmap' ) ) {
	document.cookie = 'cc_gmap=1;path=/';
}
		
		
		

		
	

	