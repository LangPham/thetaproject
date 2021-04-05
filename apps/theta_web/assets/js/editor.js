import "../css/editor.scss";
import EasyMDE from "easymde/dist/easymde.min.js";

export function create_editor(option) {
	var sim = new EasyMDE({
		element: document.getElementById(option),

		shortcuts: {
			"imageupload": "Ctrl-Alt-U", // alter the shortcut for toggleOrderedList
			//"toggleCodeBlock": null, // unbind Ctrl-Alt-C
			//"drawTable": "Cmd-Alt-T" // bind Cmd-Alt-T to drawTable action, which doesn't come with a default shortcut
		},
		autoDownloadFontAwesome: false,
		spellChecker: false,
		promptURLs: true,
		toolbar: [
			{name: "bold", action: EasyMDE.toggleBold, className: "fas fa-bold", title: "Bold",},
			{
				name: "italic",
				action: EasyMDE.toggleStrikethrough,
				className: "fa fa-strikethrough",
				title: "Strikethrough",
			},
			{name: "strikethrough", action: EasyMDE.toggleItalic, className: "fas fa-italic", title: "Italic",},
			{
				name: "heading-1",
				action: EasyMDE.toggleHeading1,
				className: "fas fa-heading fa-header-1",
				title: "Heading-1",
			},
			{
				name: "heading-2",
				action: EasyMDE.toggleHeading2,
				className: "fas fa-heading fa-header-2",
				title: "Heading-2",
			},
			{
				name: "heading-3",
				action: EasyMDE.toggleHeading3,
				className: "fas fa-heading fa-header-3",
				title: "Heading-3",
			},
			"|",
			{name: "code", action: EasyMDE.toggleCodeBlock, className: "fas fa-code", title: "Code",},
			{name: "quote", action: EasyMDE.toggleBlockquote, className: "fas fa-quote-left", title: "Quote",},
			{
				name: "unordered-list",
				action: EasyMDE.toggleUnorderedList,
				className: "fas fa-list-ul",
				title: "Generic List",
			},
			{
				name: "ordered-list",
				action: EasyMDE.toggleOrderedList,
				className: "fas fa-list-ol",
				title: "Numbered List",
			},
			{name: "table", action: EasyMDE.drawTable, className: "fas fa-table", title: "Insert Table",},
			{
				name: "horizontal-rule",
				action: EasyMDE.drawHorizontalRule,
				className: "fas fa-minus",
				title: "Insert Horizontal Line",
			},
			{
				name: "clean-block",
				action: EasyMDE.cleanBlock,
				className: "fas fa-eraser fa-clean-block",
				title: "Clean block",
			},
			"|",
			{
				name: "link",
				action: EasyMDE.drawLink,
				className: "fas fa-link no-mobile",
				title: "Create Link",
			},
			{
				name: "image",
				action: EasyMDE.drawImage,
				className: "fas fa-image",
				title: "Link Image",
			},

			// {
			// 	name: "imageupload",
			//
			// 	action: function imageupload(editor) {
			//
			// 		let input = document.getElementById("upInput");
			// 		input.click();
			// 		input.onchange = updateValue;
			//
			// 		function updateValue(ev) {
			// 			console.log(ev);
			// 			console.log(ev.target.files[0]);
			//
			// 			var elements = document.cookie.split('=');
			// 			console.log(elements);
			//
			// 			var formData = new FormData();
			// 			let fileData = ev.target.files[0];
			// 			let token = "sdfsdf";
			//
			// 			formData.append('fileUpload', fileData);
			//
			// 			fetch("/api/upload",
			// 					{
			// 						method: "POST",
			// 						body: formData,
			// 						// headers: {
			// 						//     'Accept': 'application/json',
			// 						//     'Content-Type': 'application/json',
			// 						//     'Authorization': 'Bearer ' + token,
			// 						// }
			//
			// 					})
			// 					.then(function (res) {
			// 						let re = res.json()
			// 						return re;
			// 					})
			// 					.then((myJson) => {
			// 						let file_name = myJson.data;
			// 						var cm = editor.codemirror;
			// 						let alt = "";
			// 						let url = file_name;
			// 						cm.replaceSelection(`![${alt}](${url})`);
			// 						cm.focus();
			// 					})
			// 			input.value = "";
			// 		}
			// 	},
			// 	className: "fas fa-upload",
			// 	title: "Upload Image",
			// },

			{
				name: "selectupload",

				action: function selectupload(editor) {

					let imgSelect = document.getElementById("imgSelect");
					let host = window.location.host;
					let protocol = window.location.protocol;
					let url = protocol + "//" + host + "/admin/media-live?id=imgSelect";
					window.open(
							url,
							"DescriptiveWindowName",
							"resizable,status"
					);

					let descriptort = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(imgSelect), 'value');
					Object.defineProperty(imgSelect, 'value', {
						set: function (t) {
							if (t !== ''){
								//console.log("day laf:" +t);
								update(t);
							}
							return descriptort.set.apply(this, arguments);
						},
						get: function () {
							return descriptort.get.apply(this);
						}
					});

					function update(file) {

						let file_name = file;
						var cm = editor.codemirror;
						let alt = "";
						cm.replaceSelection(`![${alt}](${file_name})`);
						cm.focus();
						//imgSelect.value = "";
					}
				},
				className: "fas fa-images",
				title: "Select Image",
			},
			"|",
			{
				name: "preview",
				action: EasyMDE.togglePreview,
				className: "fas fa-eye no-disable",
				title: "Toggle Preview",
			},
			{
				name: "side-by-side",
				action: EasyMDE.toggleSideBySide,
				className: "fas fa-columns no-disable no-mobile",
				title: "Toggle Side by Side",
			},
			{
				name: "fullscreen",
				action: EasyMDE.toggleFullScreen,
				className: "fas fa-arrows-alt no-disable no-mobile",
				title: "Toggle Fullscreen",
			},
			"|",
			{name: "undo", action: EasyMDE.togglePreview, className: "fas fa-undo no-disable", title: "Undo",},
			{name: "redo", action: EasyMDE.togglePreview, className: "fas fa-repeat no-disable", title: "Redo",},
			"|",
			{
				name: "Help",
				action: () => alert('Help'),
				className: "fas fa-question-circle",
				title: "Help",
			},
		]
	});
}

