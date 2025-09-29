defmodule Newsletter do
  def read_emails(path) do
    {status, emails} = File.read(path)
    if status == :ok do
      emails
      |> String.trim()
      |> String.split("\n", trim: true)
    else
      []
    end
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    IO.puts(pid, email)
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    emails = read_emails(emails_path)
    log_pid = open_log(log_path)
    for email <- emails do
      status = send_fun.(email)
      if status == :ok do
        log_sent_email(log_pid, email)
      end
    end
    close_log(log_pid)
  end
end
