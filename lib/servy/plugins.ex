defmodule Servy.Plugins do
  require Logger

  alias Servy.Conv

  @doc "Logs a 404 request"
  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warning("#{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(%Conv{} = conv, %{"id" => id, "thing" => thing}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(%Conv{} = conv) do
    IO.inspect conv
    conv
  end

  def warning_text(text) do
    warning_color("Warning: ") <> text
  end

  def error_text(text) do
    error_color("Error: ") <> text
  end

  defp warning_color(text) do
    IO.ANSI.yellow() <> text <> IO.ANSI.reset()
  end

  defp error_color(text) do
    IO.ANSI.red() <> text <> IO.ANSI.reset()
  end
end