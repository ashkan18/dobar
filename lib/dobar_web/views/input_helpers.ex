defmodule DovarWeb.InputHelpers do
  use Phoenix.HTML

  def csv_input(form, field, input_opts \\ [], data \\ []) do
    type = Phoenix.HTML.Form.input_type(form, field)
    name = Phoenix.HTML.Form.input_type(form, field) <> "csv"
    opts = Keyword.put_new(input_opts, :name, name)

    content_tag :li do
      [
        apply(Phoenix.HTML.Form, type, [form, field, opts])
      ]
    end
  end
end
