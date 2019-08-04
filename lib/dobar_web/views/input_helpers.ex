defmodule DovarWeb.InputHelpers do
  use Phoenix.HTML

  def csv_input(form, field, input_opts \\ [], _data \\ []) do
    type = Phoenix.HTML.Form.input_type(form, field)
    value = Phoenix.HTML.Form.input_value(form, field) || []
    field_name = Atom.to_string(field)
    old_name = Phoenix.HTML.Form.input_name(form, field)
    new_name = String.replace(old_name, field_name, field_name <> "_csv")

    opts =
      input_opts
      |> Keyword.put_new(:name, new_name)
      |> Keyword.put_new(:value, Enum.join(value, ","))

    content_tag :div do
      [
        apply(Phoenix.HTML.Form, type, [form, field, opts])
      ]
    end
  end
end
