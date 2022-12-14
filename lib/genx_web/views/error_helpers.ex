defmodule GenxWeb.ErrorHelpers do
  @moduledoc false

  use Phoenix.HTML

  @type form :: Phoenix.HTML.Form.t()
  @type field :: Phoenix.HTML.Form.field()
  @type html :: Phoenix.HTML.safe()

  @doc """
  Generates tag for inlined form input errors.
  """
  @spec error_tag(form, field) :: [html]
  def error_tag(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  @doc """
  Translates an error message using gettext.
  """
  @spec translate_error({String.t(), Keyword.t()}) :: String.t()
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(GenxWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(GenxWeb.Gettext, "errors", msg, opts)
    end
  end
end
