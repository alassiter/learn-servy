defmodule Servy.FileHandler do
  import Servy.Plugins, only: [error_text: 1]

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 500, resp_body: error_text("File not found!")}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: error_text(reason)}
  end
end