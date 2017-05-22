defmodule Unix do

   def ps_ax do
     """
     marcel           78477   0.0  0.0 556636296    300   ??  S    Mon10AM   0:00.55 /Applications/Do
     marcel           78476   0.0  0.0 556706496    516   ??  S    Mon10AM   0:00.42 /Applications/Do
     marcel           78461   0.0  0.1  2650584  20832   ??  S    Mon10AM   0:31.76 /Applications/Do
     marcel           66305   0.0  0.1  3622000  24552   ??  Ss   Sun11PM   0:24.89 /System/Library/
     marcel           53187   0.0  0.0  2567472   5332 s012  S+   Sun06PM   0:07.88 vim web/controll
     marcel           51869   0.0  0.0  2432792      8 s013  S+   Sun03PM   0:00.00 cat
     marcel           51867   0.0  0.0  2498860      8 s013  Ss+  Sun03PM   0:00.00 -zsh
     marcel           51469   0.0  0.0  2498924      8 s012  S    Sun03PM   0:00.65 -zsh
     root             51468   0.0  0.0  2514524      8 s012  S    Sun03PM   0:00.05 /usr/bin/login -
     marcel           51467   0.0  0.0  2508716    364 s012  Ss   Sun03PM   0:00.16 /Users/marcel/Ap
     marcel           37244   0.0  0.0  3598960    640   ??  S    Sun03PM   0:07.07 /System/Library/
     marcel           37178   0.0  0.0  2541164   2308   ??  S    Sun03PM   0:01.45 /System/Library/
     root             19964   0.0  0.0  2465840      8   ??  SNs  14May17   0:00.01 /usr/libexec/per
     marcel           16750   0.0  0.0  2564740    624   ??  Ss   14May17   0:00.66 /System/Library/
     marcel           63989   0.0  0.0  2567348   6412 s003  S+   14May17   0:26.62 vim
     marcel           34662   0.0  0.0  2518716    624   ??  Ss   14May17   0:00.56 /System/Library/
     """
   end

  def grep(input, match) do
    String.split(input, "\n")
      |> Enum.filter(fn(line) -> Regex.match?(match, line) end)
  end

  def awk(lines, column) do
    Enum.map(lines, fn(line) ->
      stripped = String.strip(line)
      Regex.split(~r/ /, stripped, trim: true)
        |> Enum.at(column-1)
    end)
  end
end

defmodule PipeOperatorPlaygroundTest do
  use ExUnit.Case

  test "ps_ax outputs some processes" do
    output = """
    marcel           78477   0.0  0.0 556636296    300   ??  S    Mon10AM   0:00.55 /Applications/Do
    marcel           78476   0.0  0.0 556706496    516   ??  S    Mon10AM   0:00.42 /Applications/Do
    marcel           78461   0.0  0.1  2650584  20832   ??  S    Mon10AM   0:31.76 /Applications/Do
    marcel           66305   0.0  0.1  3622000  24552   ??  Ss   Sun11PM   0:24.89 /System/Library/
    marcel           53187   0.0  0.0  2567472   5332 s012  S+   Sun06PM   0:07.88 vim web/controll
    marcel           51869   0.0  0.0  2432792      8 s013  S+   Sun03PM   0:00.00 cat
    marcel           51867   0.0  0.0  2498860      8 s013  Ss+  Sun03PM   0:00.00 -zsh
    marcel           51469   0.0  0.0  2498924      8 s012  S    Sun03PM   0:00.65 -zsh
    root             51468   0.0  0.0  2514524      8 s012  S    Sun03PM   0:00.05 /usr/bin/login -
    marcel           51467   0.0  0.0  2508716    364 s012  Ss   Sun03PM   0:00.16 /Users/marcel/Ap
    marcel           37244   0.0  0.0  3598960    640   ??  S    Sun03PM   0:07.07 /System/Library/
    marcel           37178   0.0  0.0  2541164   2308   ??  S    Sun03PM   0:01.45 /System/Library/
    root             19964   0.0  0.0  2465840      8   ??  SNs  14May17   0:00.01 /usr/libexec/per
    marcel           16750   0.0  0.0  2564740    624   ??  Ss   14May17   0:00.66 /System/Library/
    marcel           63989   0.0  0.0  2567348   6412 s003  S+   14May17   0:26.62 vim
    marcel           34662   0.0  0.0  2518716    624   ??  Ss   14May17   0:00.56 /System/Library/
    """
    assert Unix.ps_ax == output
  end

  test "grep(lines, thing) returns lines that match 'thing'" do
    lines = """
    foo
    bar
    thing foobaz
    thing qux
    """
    output = ["thing foobaz", "thing qux"]

    assert Unix.grep(lines, ~r/thing/) == output
  end

  test "awk(input, 1) splits on whitespace and return the first column" do
    input = ["foo bar", " baz    qux"]
    output = ["foo", "baz"]
    assert Unix.awk(input, 1) == output
  end

  test "the whole pipeline works" do
    assert (Unix.ps_ax |> Unix.grep(~r/vim/) |> Unix.awk(2)) == ["53187", "63989"]
  end
end
