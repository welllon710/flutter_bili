import zipfile

# ====== 思维导图数据结构 ======
data = {
    "name": "院校管理",
    "children": [
        {"name": "院校管理", "children": ["院校信息维护","院校信息维护(院校)"]},
        {"name": "学科管理", "children": ["学科信息维护", "学科信息查询(院)","公安类本科专业设置请况","公安类专科专业设置请况"]},
        {"name": "学生管理", "children": ["学生信息维护(院校)", "省级单位查询"]},
        {"name": "统计模块", "children": ["基础设施情况(一)", "基础设施情况(二)","年度公安院校基础设施设备情况","经费收支情况","招生及在校生情况"]},
        {"name": "教育督导", "children": []},
    ]
}

# ====== XMind 结构生成函数 ======
def build(node):
    title = node["name"]
    if "children" not in node:
        return f'<topic><title>{title}</title></topic>'
    children_xml = "".join(build(c if isinstance(c, dict) else {"name": c}) for c in node["children"])
    return f'<topic><title>{title}</title><children><topics type="attached">{children_xml}</topics></children></topic>'

# ====== 生成 XML 内容 ======
content_xml = f"""<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xmap-content xmlns="urn:xmind:xmap:xmlns:content:2.0" version="2.0">
  <sheet id="1" topic-href="#2">
    <title>{data['name']}</title>
    {build(data)}
  </sheet>
</xmap-content>
"""

meta_xml = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<meta xmlns="urn:xmind:xmap:xmlns:meta:2.0">
  <Creator>ChatGPT</Creator>
  <Comment>自动生成的院校管理思维导图</Comment>
</meta>
"""

manifest_xml = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<manifest xmlns="urn:xmind:xmap:xmlns:manifest:1.0">
  <file-entry full-path="content.xml" media-type="text/xml"/>
  <file-entry full-path="meta.xml" media-type="text/xml"/>
</manifest>
"""

# ====== 生成 .xmind 文件 ======
with zipfile.ZipFile("院校管理.xmind", "w") as z:
    z.writestr("content.xml", content_xml)
    z.writestr("meta.xml", meta_xml)
    z.writestr("META-INF/manifest.xml", manifest_xml)

print("✅ 已成功生成：院校管理.xmind")
