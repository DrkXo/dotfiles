-- ~/.config/nvim/lua/plugins/snippets.lua
return {
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        config = function()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local c = ls.choice_node
        local d = ls.dynamic_node
        local sn = ls.snippet_node
        local fmt = require("luasnip.extras.fmt").fmt
        local rep = require("luasnip.extras").rep

        -- Flutter/Dart specific snippets
        ls.add_snippets("dart", {
            -- StatelessWidget
            s("stless", fmt([[
                class {} extends StatelessWidget {{
                    const {}({{super.key}});

                    @override
                    Widget build(BuildContext context) {{
                        return {};
                    }}
                }}
            ]], {
                i(1, "MyWidget"),
                            rep(1),
                            i(2, "Container()")
            })),

            -- StatefulWidget
            s("stful", fmt([[
                class {} extends StatefulWidget {{
                    const {}({{super.key}});

                    @override
                    State<{}> createState() => _{}State();
                }}

                class _{}State extends State<{}> {{
                    @override
                    Widget build(BuildContext context) {{
                        return {};
                    }}
                }}
            ]], {
                i(1, "MyWidget"),
                           rep(1),
                           rep(1),
                           rep(1),
                           rep(1),
                           rep(1),
                           i(2, "Container()")
            })),

            -- Widget build method
            s("build", fmt([[
                @override
                Widget build(BuildContext context) {{
                    return {};
                }}
            ]], {
                i(1, "Container()")
            })),

            -- InitState
            s("initstate", fmt([[
                @override
                void initState() {{
                    super.initState();
                    {}
                }}
            ]], {
                i(1, "// TODO: implement initState")
            })),

            -- Dispose
            s("dispose", fmt([[
                @override
                void dispose() {{
                    {}
                    super.dispose();
                }}
            ]], {
                i(1, "// TODO: implement dispose")
            })),

            -- Scaffold
            s("scaffold", fmt([[
                Scaffold(
                    appBar: AppBar(
                        title: Text('{}'),
                    ),
                    body: {},
                )
            ]], {
                i(1, "Title"),
                              i(2, "Container()")
            })),

            -- Column
            s("col", fmt([[
                Column(
                    children: [
                        {},
                    ],
                )
            ]], {
                i(1, "// TODO: Add children")
            })),

            -- Row
            s("row", fmt([[
                Row(
                    children: [
                        {},
                    ],
                )
            ]], {
                i(1, "// TODO: Add children")
            })),

            -- Container
            s("container", fmt([[
                Container(
                    child: {},
                )
            ]], {
                i(1, "// TODO: Add child")
            })),

            -- Padding
            s("padding", fmt([[
                Padding(
                    padding: const EdgeInsets.all({}),
                        child: {},
                )
            ]], {
                i(1, "8.0"),
                             i(2, "// TODO: Add child")
            })),

            -- Center
            s("center", fmt([[
                Center(
                    child: {},
                )
            ]], {
                i(1, "// TODO: Add child")
            })),

            -- Elevated Button
            s("elevatedbutton", fmt([[
                ElevatedButton(
                    onPressed: () {{
                        {};
                    }},
                    child: Text('{}'),
                )
            ]], {
                i(1, "// TODO: Add onPressed logic"),
                                    i(2, "Button Text")
            })),

            -- Text Button
            s("textbutton", fmt([[
                TextButton(
                    onPressed: () {{
                        {};
                    }},
                    child: Text('{}'),
                )
            ]], {
                i(1, "// TODO: Add onPressed logic"),
                                i(2, "Button Text")
            })),

            -- Icon Button
            s("iconbutton", fmt([[
                IconButton(
                    onPressed: () {{
                        {};
                    }},
                    icon: Icon(Icons.{}),
                )
            ]], {
                i(1, "// TODO: Add onPressed logic"),
                                i(2, "add")
            })),

            -- ListView Builder
            s("listviewbuilder", fmt([[
                ListView.builder(
                    itemCount: {},
                    itemBuilder: (context, index) {{
                        return {};
                    }},
                )
            ]], {
                i(1, "items.length"),
                                     i(2, "ListTile(title: Text('Item $index'))")
            })),

            -- GridView Builder
            s("gridviewbuilder", fmt([[
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: {},
                    ),
                    itemCount: {},
                    itemBuilder: (context, index) {{
                        return {};
                    }},
                )
            ]], {
                i(1, "2"),
                                     i(2, "items.length"),
                                     i(3, "Container()")
            })),

            -- Future Builder
            s("futurebuilder", fmt([[
                FutureBuilder<{}>(
                    future: {},
                    builder: (context, snapshot) {{
                        if (snapshot.connectionState == ConnectionState.waiting) {{
                            return CircularProgressIndicator();
                        }}
                        if (snapshot.hasError) {{
                            return Text('Error: ${{snapshot.error}}');
                        }}
                        return {};
                    }},
                )
            ]], {
                i(1, "dynamic"),
                                   i(2, "future"),
                                   i(3, "Text('${snapshot.data}')")
            })),

            -- Stream Builder
            s("streambuilder", fmt([[
                StreamBuilder<{}>(
                    stream: {},
                    builder: (context, snapshot) {{
                        if (snapshot.hasError) {{
                            return Text('Error: ${{snapshot.error}}');
                        }}
                        if (!snapshot.hasData) {{
                            return CircularProgressIndicator();
                        }}
                        return {};
                    }},
                )
            ]], {
                i(1, "dynamic"),
                                   i(2, "stream"),
                                   i(3, "Text('${snapshot.data}')")
            })),

            -- Navigator push
            s("navpush", fmt([[
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => {}()),
                );
            ]], {
                i(1, "NextPage")
            })),

            -- Show Dialog
            s("showdialog", fmt([[
                showDialog(
                    context: context,
                    builder: (BuildContext context) {{
                        return AlertDialog(
                            title: Text('{}'),
                                           content: Text('{}'),
                                           actions: [
                                               TextButton(
                                                   onPressed: () {{
                                                       Navigator.of(context).pop();
                                                   }},
                                                   child: Text('OK'),
                                               ),
                                           ],
                        );
                    }},
                );
            ]], {
                i(1, "Dialog Title"),
                                i(2, "Dialog Content")
            })),

            -- Show Snackbar
            s("snackbar", fmt([[
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('{}'),
                             duration: Duration(seconds: {}),
                    ),
                );
            ]], {
                i(1, "Snackbar message"),
                              i(2, "2")
            })),

            -- TextFormField
            s("textformfield", fmt([[
                TextFormField(
                    decoration: InputDecoration(
                        labelText: '{}',
                        hintText: '{}',
                    ),
                    validator: (value) {{
                        if (value == null || value.isEmpty) {{
                            return 'Please enter {}';
                        }}
                        return null;
                    }},
                    onSaved: (value) {{
                        {};
                    }},
                )
            ]], {
                i(1, "Label"),
                                   i(2, "Hint"),
                                   rep(1),
                                   i(3, "// TODO: Save value")
            })),

            -- Animation Controller
            s("animcontroller", fmt([[
                late AnimationController {};
                late Animation<double> {};

                @override
                void initState() {{
                    super.initState();
                    {} = AnimationController(
                        duration: Duration(milliseconds: {}),
                                             vsync: this,
                    );
                    {} = Tween<double>(begin: 0.0, end: 1.0).animate({});
                }}

                @override
                void dispose() {{
                    {}.dispose();
                    super.dispose();
                }}
            ]], {
                i(1, "_controller"),
                                    i(2, "_animation"),
                                    rep(1),
                                    i(3, "1000"),
                                    rep(2),
                                    rep(1),
                                    rep(1)
            })),
        })

        -- Set up keymaps for snippets
        vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-E>", function()
        if ls.choice_active() then
            ls.change_choice(1)
            end
            end, {silent = true})
        end,
    },
}
