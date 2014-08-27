$XmlFile = Get-Item ".\SCA-LogCollectionMP\bin\Release\SCALogCollectionMP.xml";
[xml]$XML = Get-Content $XmlFile.FullName;
$References = $XML.ManagementPack.Manifest.References |Select-Object -ExpandProperty Reference;
[bool]$Found = $false;
Foreach ($Item in $References)
{
    if ($Item.Alias -eq "IPTypes")
    {
        $Found = $true;
        }
    }
if (!($Found))
{
    #
    # Add the reference xml here
    #
    $IPTypes = $XML.CreateElement("Reference");
    $IPTypes.SetAttribute("Alias","IPTypes");
    $IPTypes.InnerXml = "<ID>Microsoft.IntelligencePacks.Types</ID><Version>7.0.9412.0</Version><PublicKeyToken>31bf3856ad364e35</PublicKeyToken>";
    $XML.SelectNodes("//References").AppendChild($IPTypes);
    }
$Rules = $XML.ManagementPack.Monitoring.Rules |Select-Object -ExpandProperty Rule;
foreach ($Rule in $Rules)
{
    foreach ($Element in $Rule.WriteActions)
    {
        $WriteAction = $XML.CreateElement("WriteAction");
        $WriteAction.SetAttribute("ID","HttpWA");
        $WriteAction.SetAttribute("TypeID","IPTypes!Microsoft.SystemCenter.CollectCloudGenericEvent");
        $Element.RemoveAll();
        $Element.AppendChild($WriteAction);
        }
    }
$XML.Save($XmlFile.FullName);