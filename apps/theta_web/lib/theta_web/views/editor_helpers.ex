defmodule ThetaWeb.EditorHelpers do
  @moduledoc false
  use Phoenix.HTML

  import ThetaWeb.ErrorHelpers

  def simplemde(form, field) do
    text = Phoenix.HTML.Form.textarea(form, field)
    element = input_id(form, field)

    content_tag :div do
      style = raw("<link rel=\"stylesheet\" href=\"/css/editor.css\")>")
      script = raw("<script type=\"text/javascript\" src=\"/js/editor.js\")></script>")
      script_inline = raw("<script type=\"text/javascript\">editor.create_editor(\"" <> element <> "\")</script>")
      file_hidden = raw(
        "<input style='display:none'  accept='image/gif,image/jpeg,image/jpg,image/png' type='file' id='upInput'>"
      )
      [style, text, script, script_inline, file_hidden]
    end
  end

  @doc """
    <div id="file-js-example" class="file has-name">
      <label class="file-label">
        <input class="file-input" type="file" name="resume">
        <span class="file-cta">
          <span class="file-icon">
            <i class="fas fa-upload"></i>
          </span>
          <span class="file-label">
            Choose a file…
          </span>
        </span>
        <span class="file-name">
          No file uploaded
        </span>
      </label>
    </div>

    <script>
      const fileInput = document.querySelector('#file-js-example input[type=file]');
      fileInput.onchange = () => {
        if (fileInput.files.length > 0) {
          const fileName = document.querySelector('#file-js-example .file-name');
          fileName.textContent = fileInput.files[0].name;
        }
      }
    </script>
  """

  def file_input_bulma(form, field, label \\ true, opt \\[]) do
    error_html = error_tag(form, field)
    IO.inspect input_id(form, field)
    script_inline = raw(
      "<script>
    const fileInput = document.querySelector('#"<>input_id(form, field)<>"');
    fileInput.onchange = () => {
      if (fileInput.files.length > 0) {
        const fileName = document.querySelector('#"<>input_id(form, field)<>" ~ .file-name');
        fileName.textContent = fileInput.files[0].name;
      }
    }
  </script>"
    )
    label_html = if label do
      label form, field, class: "label"
    else
      ""
    end
    opt_in = check_field_error(error_html, "file has-name is-fullwidth", opt)
    field_html = Phoenix.HTML.Form.file_input(form, field, [class: "file-input"])
    content_tag :div, opt_in do
      label form, field, class: "file-label" do
        addon = raw "<span class='file-cta'>
                        <span class='file-icon'>
                           <i class='fa fa-upload'></i>
                        </span>
                        <span class='file-label'>
                          Choose a file…
                        </span>
                    </span>
                    <span class='file-name'>
                      No file uploaded
                    </span>"
        [label_html, field_html, addon, script_inline]
      end
    end
  end

  def text_input_bulma(form, field, opt \\ []) do
    #  <div class="field">
    #    <label class="label" for="article_title">Title</label>
    #    <div class="control">
    #      <input class="input" id="article_title" name="article[title]" type="text">
    #      </div>
    #  </div>
    #<%= error_tag f, :title %>
    error_html = error_tag(form, field)
    opt_in = check_field_error(error_html, "input", opt)
    label_html = label form, field, class: "label"
    #IO.inspect error_html
    field_html = Phoenix.HTML.Form.text_input(form, field, opt_in)
    content_tag :div, class: "field" do
      [
        label_html,
        content_tag :div, class: "control" do
          [field_html]
        end,
        error_html
      ]
    end
  end
  def password_input_bulma(form, field, opt \\ []) do
    #  <div class="field">
    #    <label class="label" for="article_title">Title</label>
    #    <div class="control">
    #      <input class="input" id="article_title" name="article[title]" type="text">
    #      </div>
    #  </div>
    #<%= error_tag f, :title %>
    error_html = error_tag(form, field)
    opt_in = check_field_error(error_html, "input", opt)
    label_html = label form, field, class: "label"
    #IO.inspect error_html
    field_html = Phoenix.HTML.Form.password_input(form, field, opt_in)
    content_tag :div, class: "field" do
      [
        label_html,
        content_tag :div, class: "control" do
          [field_html]
        end,
        error_html
      ]
    end
  end
  @doc """
  <div class="field">
      <div class="control">
        <label class="checkbox">
          <%= checkbox f, :is_serial %>
            Is Serial
        </label>
        <%= error_tag f, :is_serial %>
      </div>
  </div>
  """
  def checkbox_bulma(form, field, opt \\ []) do
    #label_html = label form, field, class: "label"
    error_html = error_tag(form, field)
    field_html = Phoenix.HTML.Form.checkbox(form, field, opt)
    content_tag :div, class: "field" do

      content_tag :div, class: "control" do
        [
          content_tag :label, class: "checkbox" do
            [field_html, " " <> humanize(field)]
          end,
          error_html
        ]
      end

    end
  end

  @doc """
  <div class="field">
      <%= label f, :menu_id, class: "label" %>
      <div class="control">
  	    <div class="select">
  		    <%= select(f, :menu_id, Enum.map(@menu, &{&1.title, &1.id}), prompt: "--Choose menu--", selected: @changeset.data.menu_id) %>
  	    </div>
        <%= error_tag f, :menu_id %>
      </div>
  	</div>
  """
  def select_bulma(form, field, options, opt \\ []) do
    label_html = label form, field, class: "label"
    error_html = error_tag(form, field)
    opt_in = check_field_error(error_html, "select")
    field_html = Phoenix.HTML.Form.select(form, field, options, opt)
    content_tag :div, class: "field" do
      [
        label_html,
        content_tag :div, class: "control" do
          [
            content_tag :div, opt_in do
              field_html
            end,
            error_html
          ]
        end
      ]
    end
  end

  defp check_field_error(error_html, class, opt \\ []) do
    class =
      if error_html != [] do
        class <> " is-danger"
      else
        class
      end

    opt_in = if List.keymember?(opt, :class, 0) do
      List.keyreplace(opt, :class, 0, {:class, "#{class} #{opt[:class]}"})
    else
      List.keystore(opt, :class, 0, {:class, class})
    end
    opt_in
  end

  @doc """
  <div class="field">
   <div class="control">
     <%= submit("Save", class: "button is-link") %>
   </div>
  </div>
  """
  def submit_bulma(value, _opt \\ []) do

    field_html = Phoenix.HTML.Form.submit(value, class: "button is-link")
    content_tag :div, class: "field" do
      [
        content_tag :div, class: "control" do
          [
            field_html
          ]
        end
      ]
    end
  end

  def filter_input(id, column, placeholder \\ 'Search') do
    table_column = "#{id}_#{column}()"
    atom_key = "key_"<>"#{column}"
    field_html = Phoenix.HTML.Form.text_input(:search, String.to_atom(atom_key), onkeyup: table_column, placeholder: placeholder, class: "input")
    script = raw("
      <script>
        function "<>"#{table_column}"<>" {
          // Declare variables
          let input, filter, table, tr, td, i, txtValue;
          input = document.getElementById('search_"<>"#{atom_key}"<>"');
          filter = input.value.toUpperCase();
          table = document.getElementById(\'"<> "#{id}" <>"\');
          tr = table.getElementsByTagName('tr');

          // Loop through all table rows, and hide those who don't match the search query
          for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName('td')[" <> "#{column}" <> "];
            if (td) {
              txtValue = td.textContent || td.innerText;
              if (txtValue.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = '';
              } else {
                tr[i].style.display = 'none';
              }
            }
          }
        }
      </script>
    ")
    content_tag :div, class: "field" do
      [
        content_tag :div, class: "control" do
          [
            field_html, script
          ]
        end
      ]
    end
  end
end

