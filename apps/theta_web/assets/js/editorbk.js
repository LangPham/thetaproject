import "simplemde/dist/simplemde.min.css";
import SimpleMDE from 'simplemde';
// "<%= javascript_escape(render("post.html", post: @post)) %>"
// function sayHello() {
//     console.log("<%= javascript_escape(element) %>")
// }

export function creat_editor(option) {
    var sim = new SimpleMDE({
        element: document.getElementById(option),
        //    element: document.getElementById("<%= javascript_escape(element) %>"),
        shortcuts: {
            "imageupload": "Ctrl-Alt-U", // alter the shortcut for toggleOrderedList
            //"toggleCodeBlock": null, // unbind Ctrl-Alt-C
            //"drawTable": "Cmd-Alt-T" // bind Cmd-Alt-T to drawTable action, which doesn't come with a default shortcut
        },
        autoDownloadFontAwesome: false,
        spellChecker: false,
        promptURLs: true,
        toolbar: [
            {name: "bold", action: SimpleMDE.toggleBold, className: "fa fa-bold", title: "Bold",},
            {
                name: "italic",
                action: SimpleMDE.toggleStrikethrough,
                className: "fa fa-strikethrough",
                title: "Strikethrough",
            },
            {name: "strikethrough", action: SimpleMDE.toggleItalic, className: "fa fa-italic", title: "Italic",},
            {
                name: "heading-1",
                action: SimpleMDE.toggleHeading1,
                className: "fas fa-heading fa-header-1",
                title: "Heading-1",
            },
            {
                name: "heading-2",
                action: SimpleMDE.toggleHeading2,
                className: "fas fa-heading fa-header-2",
                title: "Heading-2",
            },
            {
                name: "heading-3",
                action: SimpleMDE.toggleHeading3,
                className: "fas fa-heading fa-header-3",
                title: "Heading-3",
            },
            "|",
            {name: "code", action: SimpleMDE.toggleCodeBlock, className: "fas fa-code", title: "Code",},
            {name: "quote", action: SimpleMDE.toggleBlockquote, className: "fas fa-quote-left", title: "Quote",},
            {
                name: "unordered-list",
                action: SimpleMDE.toggleUnorderedList,
                className: "fas fa-list-ul",
                title: "Generic List",
            },
            {
                name: "ordered-list",
                action: SimpleMDE.toggleOrderedList,
                className: "fas fa-list-ol",
                title: "Numbered List",
            },
            {name: "table", action: SimpleMDE.drawTable, className: "fas fa-table", title: "Insert Table",},
            {
                name: "horizontal-rule",
                action: SimpleMDE.drawHorizontalRule,
                className: "fas fa-minus",
                title: "Insert Horizontal Line",
            },
            {
                name: "clean-block",
                action: SimpleMDE.cleanBlock,
                className: "fas fa-eraser fa-clean-block",
                title: "Clean block",
            },
            "|",
            {
                name: "link",
                action: SimpleMDE.drawLink,
                className: "fas fa-link no-mobile",
                title: "Create Link",
            },
            {
                name: "image",
                action: SimpleMDE.drawImage,
                className: "fas fa-image",
                title: "Link Image",
            },

            {
                name: "imageupload",

                action: function imageupload(editor) {

                    let input = document.getElementById("upInput");
                    input.click();
                    input.onchange = updateValue;

                    function updateValue(ev) {
                        //console.log(ev.target.files[0]);


                        var elements = document.cookie.split('=');
                        console.log(elements);


                        var formData = new FormData();
                        let fileData = ev.target.files[0];
                        let token = "sdfsdf";

                        formData.append('fileUpload', fileData);

                        fetch("/api/upload",
                            {
                                method: "POST",
                                body: formData,
                                // headers: {
                                //     'Accept': 'application/json',
                                //     'Content-Type': 'application/json',
                                //     'Authorization': 'Bearer ' + token,
                                // }

                            })
                            .then(function (res) {
                                let re = res.json()
                                return re;
                            })
                            .then((myJson) => {
                                let file_name = myJson.data;
                                var cm = editor.codemirror;
                                let alt = "";
                                let url = file_name;
                                cm.replaceSelection(`![${alt}](${url})`);
                                cm.focus();
                            })
                        input.value = "";
                    }
                },
                className: "fas fa-upload",
                title: "Upload Image",
            },
            "|",
            {
                name: "preview",
                action: SimpleMDE.togglePreview,
                className: "fas fa-eye no-disable",
                title: "Toggle Preview",
            },
            {
                name: "side-by-side",
                action: SimpleMDE.toggleSideBySide,
                className: "fas fa-columns no-disable no-mobile",
                title: "Toggle Side by Side",
            },
            {
                name: "fullscreen",
                action: SimpleMDE.toggleFullScreen,
                className: "fas fa-arrows-alt no-disable no-mobile",
                title: "Toggle Fullscreen",
            },
            "|",
            {name: "undo", action: SimpleMDE.togglePreview, className: "fas fa-undo no-disable", title: "Undo",},
            {name: "redo", action: SimpleMDE.togglePreview, className: "fas fa-repeat no-disable", title: "Redo",},
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

