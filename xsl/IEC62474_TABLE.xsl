<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="no" />

  <!--####################################### 製品 #######################################-->
  <xsl:template match="Main/Product">
    {
      "over": [
        <xsl:apply-templates select="./Substance[Threshold/@aboveThresholdLevel='true']" />  <!--V1-->
        <xsl:apply-templates select="./SubstanceGroup[Threshold/@aboveThresholdLevel='true']" /><!--V1-->
        <xsl:apply-templates select="./Compliance/DsDsg[ComplianceThreshold/@aboveComplianceThreshold='true']" /><!--V2-->
      ],
      "lower": [
        <xsl:apply-templates select="./Substance[Threshold/@aboveThresholdLevel='false']" />  <!--V1-->
        <xsl:apply-templates select="./SubstanceGroup[Threshold/@aboveThresholdLevel='false']" /><!--V1-->
        <xsl:apply-templates select="./Compliance/DsDsg[ComplianceThreshold/@aboveComplianceThreshold='false']" /><!--V2-->
      ]
    }
  </xsl:template>

  <!--####################################### 物質 V1 #######################################-->
	<xsl:template match="Substance">
    {
      <xsl:if test="Threshold/@aboveThresholdLevel='true'">
        <xsl:call-template name="split">
          <xsl:with-param name="text" select="@comment" />
          <xsl:with-param name="col" select="number('0')" />
        </xsl:call-template>
      </xsl:if>
      "name":"<xsl:value-of select="@name" />",<!--名称(英)-->
      "MassPercent":"<xsl:value-of select="MatMassPercent/@massPercent" />",<!--含有率(%)-->
      "aboveComplianceThreshold":<xsl:value-of select="Threshold/@aboveThresholdLevel" />,<!--含有判定-->
      "reportableApplication":"<xsl:value-of select="Threshold/@reportableApplication" />",<!--報告用途-->
      "reportingThreshold":"<xsl:value-of select="Threshold/@reportingThreshold" />",<!--報告閾値-->
      "ID":"<xsl:value-of select="UniqueID/@identity" />",
      "nameJA":"<xsl:call-template name="getSubstanceName"><xsl:with-param name="id" select="string(UniqueID/@identity)" /></xsl:call-template>",
      "AppJA":"<xsl:call-template name="getSubstanceApp"><xsl:with-param name="id" select="string(UniqueID/@identity)" /></xsl:call-template>",
      "ThresholdJA":"<xsl:call-template name="getSubstanceThreshold"><xsl:with-param name="id" select="string(UniqueID/@identity)" /></xsl:call-template>"
      <xsl:apply-templates select="Exemptions" />
    }<xsl:if test="last()!=position()">,</xsl:if>
	</xsl:template>

  <!--####################################### 物質群 V1 #######################################-->
	<xsl:template match="SubstanceGroup">
    {
      <xsl:if test="Threshold/@aboveThresholdLevel='true'">
        <xsl:call-template name="split">
          <xsl:with-param name="text" select="@comment" />
          <xsl:with-param name="col" select="number('0')" />
        </xsl:call-template>
      </xsl:if>
      "name":"<xsl:value-of select="@name" />",<!--名称(英)-->
      "MassPercent":"<xsl:value-of select="MatMassPercent/@massPercent" />",<!--含有率(%)-->
      "aboveComplianceThreshold":<xsl:value-of select="Threshold/@aboveThresholdLevel" />,<!--含有判定-->
      "reportableApplication":"<xsl:value-of select="Threshold/@reportableApplication" />",<!--報告用途-->
      "reportingThreshold":"<xsl:value-of select="Threshold/@reportingThreshold" />",<!--報告閾値-->
      "ID":"<xsl:value-of select="UniqueID/@identity" />",
      "nameJA":"<xsl:call-template name="getSubstanceName"><xsl:with-param name="id" select="string(UniqueID/@identity)" /></xsl:call-template>",
      "AppJA":"<xsl:call-template name="getSubstanceApp"><xsl:with-param name="id" select="string(UniqueID/@identity)" /></xsl:call-template>",
      "ThresholdJA":"<xsl:call-template name="getSubstanceThreshold"><xsl:with-param name="id" select="string(UniqueID/@identity)" /></xsl:call-template>"
      <xsl:apply-templates select="Exemptions" />
    }<xsl:if test="last()!=position()">,</xsl:if>
	</xsl:template>

  <!--####################################### 遵法判断 V2 #######################################-->
  <xsl:template match="DsDsg">
    {
      <xsl:if test="ComplianceThreshold/@aboveComplianceThreshold='true'">
        <xsl:call-template name="split">
          <xsl:with-param name="text" select="@comment" />
          <xsl:with-param name="col" select="number('0')" />
        </xsl:call-template>
      </xsl:if>
      "name":"<xsl:value-of select="@name" />",<!--名称(英)-->
      "weight":"<xsl:value-of select="Mass/@mass" />",<!--重量-->
      "unit":"<xsl:value-of select="Mass/@unitOfMeasure" />",<!--重量単位-->
      "MassPercent":"<xsl:value-of select="MassPercent/@massPercent" />",<!--含有率(%)-->
      "aboveComplianceThreshold":<xsl:value-of select="ComplianceThreshold/@aboveComplianceThreshold" />,<!--含有判定-->
      "reportableApplication":"<xsl:value-of select="ComplianceThreshold/@reportableApplication" />",<!--報告用途(英)-->
      "reportingThreshold":"<xsl:value-of select="ComplianceThreshold/@reportingThreshold" />",<!--報告閾値(英)-->
      "ID":"<xsl:value-of select="DsDsgID/@entryIdentity" />",<!--ID-->
      "nameJA":"<xsl:call-template name="getSubstanceName"><xsl:with-param name="id" select="string(DsDsgID/@entryIdentity)" /></xsl:call-template>",
      "AppJA":"<xsl:call-template name="getSubstanceApp"><xsl:with-param name="id" select="string(DsDsgID/@entryIdentity)" /></xsl:call-template>",
      "ThresholdJA":"<xsl:call-template name="getSubstanceThreshold"><xsl:with-param name="id" select="string(DsDsgID/@entryIdentity)" /></xsl:call-template>"
      <xsl:apply-templates select="Exemptions" />
    }<xsl:if test="last()!=position()">,</xsl:if>
  </xsl:template>

  <!--####################################### 適用除外 #######################################-->
  <xsl:template match="Exemptions">
    ,"ExemptionDescription":"<xsl:value-of select="Exemption/@description" />"<!--除外内容-->
    ,"ExemptionID":"<xsl:value-of select="Exemption/@identity" />"<!--除外ID-->
    ,"ExemptionReg":"<xsl:value-of select="Exemption/@regIndex" />"<!--V2-->
    ,"UniqueIDauthority":"<xsl:value-of select="UniqueID/@authority" />"<!--対象リスト-->
    ,"UniqueIDID":"<xsl:value-of select="UniqueID/@identity" />"<!--対象リストID-->
    ,"UniqueIDversion":"<xsl:value-of select="UniqueID/@version" />"<!--V2--><!--対象リストVer-->
  </xsl:template>

<!--
##########################################################################################
		分割関数
##########################################################################################-->
  <xsl:template name="split">
    <xsl:param name="text"/>
    <xsl:param name="col"/>
    <xsl:param name="separator" select="'@'"/>
    <xsl:param name="ver" select="//Main/@schemaDatabaseVersion"/>
    <xsl:choose>
      <xsl:when test="not(contains($text, $separator))">
        "usePart":"<xsl:value-of select="normalize-space($text)"/>",
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$col=0">
          "comment":"<xsl:value-of select="normalize-space(substring-before($text, $separator))"/>",
        </xsl:if>
        <xsl:if test="$col=1 and $ver='X6.01ex1.0'">
          "weight":"<xsl:value-of select="normalize-space(substring-before($text, $separator))"/>",
        </xsl:if>
        <xsl:if test="$col=2 and $ver='X6.01ex1.0'">
          "unit":"<xsl:value-of select="normalize-space(substring-before($text, $separator))"/>",
        </xsl:if>
        <xsl:if test="$col=3">
          "use":"<xsl:value-of select="normalize-space(substring-before($text, $separator))"/>",
        </xsl:if>
        <xsl:call-template name="split">
          <xsl:with-param name="text" select="substring-after($text, $separator)"/>
          <xsl:with-param name="col" select="$col+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--
##########################################################################################
		物質名称
##########################################################################################-->
  <xsl:template name="getSubstanceName">
    <xsl:param name="id" />
    <xsl:if test="$id='00001'">五酸化二ヒ素</xsl:if>
    <xsl:if test="$id='00002'">三酸化二ヒ素</xsl:if>
    <xsl:if test="$id='00003'">アスベスト類</xsl:if>
    <xsl:if test="$id='00004'">一部の芳香族アミンを生成するアゾ染料・顔料</xsl:if>
    <xsl:if test="$id='00005'">酸化ベリリウム</xsl:if>
    <xsl:if test="$id='00007'">ホウ酸</xsl:if>
    <xsl:if test="$id='00008'">臭素系難燃剤(PBB類、PBDE類およびHBCDDを除く)</xsl:if>
    <xsl:if test="$id='00009'">臭素系難燃剤(PBB類、PBDE類およびHBCDDを除く)</xsl:if>
    <xsl:if test="$id='00010'">カドミウム/カドミウム化合物</xsl:if>
    <xsl:if test="$id='00011'">カドミウム/カドミウム化合物</xsl:if>
    <xsl:if test="$id='00012'">六価クロム化合物</xsl:if>
    <xsl:if test="$id='00013'">二塩化コバルト(II)</xsl:if>
    <xsl:if test="$id='00014'">ジブチルスズ化合物 (DBT)</xsl:if>
    <xsl:if test="$id='00015'">ジオクチルスズ化合物 (DOT)</xsl:if>
    <xsl:if test="$id='00016'">ジメチル=フマラート</xsl:if>
    <xsl:if test="$id='00017'">四ホウ酸二ナトリウム無水物</xsl:if>
    <xsl:if test="$id='00018'">フッ素系温室効果ガス (PFC, SF6, HFC)</xsl:if>
    <xsl:if test="$id='00019'">ホルムアルデヒド</xsl:if>
    <xsl:if test="$id='00020'">ヘキサブロモシクロドデカン(HBCDD)</xsl:if>
    <xsl:if test="$id='00021'">鉛/鉛化合物</xsl:if>
    <xsl:if test="$id='00022'">鉛/鉛化合物</xsl:if>
    <xsl:if test="$id='00023'">鉛/鉛化合物</xsl:if>
    <xsl:if test="$id='00024'">鉛/鉛化合物</xsl:if>
    <xsl:if test="$id='00025'">鉛/鉛化合物</xsl:if>
    <xsl:if test="$id='00026'">クロム酸鉛(II)</xsl:if>
    <xsl:if test="$id='00027'">C.I.ピグメントレッド104</xsl:if>
    <xsl:if test="$id='00028'">C.I.ピグメントイエロー34</xsl:if>
    <xsl:if test="$id='00029'">水銀/水銀化合物</xsl:if>
    <xsl:if test="$id='00030'">水銀/水銀化合物</xsl:if>
    <xsl:if test="$id='00031'">ニッケル/ニッケル化合物</xsl:if>
    <xsl:if test="$id='00032'">オゾン層破壊物質 (CFC, Halon, HBFC, HCFC その他)</xsl:if>
    <xsl:if test="$id='00033'">過塩素酸塩</xsl:if>
    <xsl:if test="$id='00035'">2-(2H-1,2,3-ベンゾトリアゾール-2-yl)-4,6-ジ-tert-ブチルフェノール</xsl:if>
    <xsl:if test="$id='00036'">フタル酸エステル類 グループ1 (BBP, DBP, DEHP, DIBP)</xsl:if>
    <xsl:if test="$id='00037'">フタル酸エステル類 グループ2 (DIDP, DINP, DNOP)</xsl:if>
    <xsl:if test="$id='00038'">フタル酸ビス(2-エチルヘキシル) (DEHP)</xsl:if>
    <xsl:if test="$id='00039'">ジブチルフタラート(DBP)</xsl:if>
    <xsl:if test="$id='00040'">ベンジル=ブタン-1-イル=フタラート(BBP)</xsl:if>
    <xsl:if test="$id='00041'">ジイソブチル=フタラート</xsl:if>
    <xsl:if test="$id='00042'">ジアルキル(C=6~8、分枝、C7に富む)=フタラート</xsl:if>
    <xsl:if test="$id='00043'">ジアルキル(C=7~11、分岐、線型)=フタラート</xsl:if>
    <xsl:if test="$id='00044'">ポリ臭化ビフェニル類(PBB類)</xsl:if>
    <xsl:if test="$id='00045'">ポリ臭化ジフェニルエーテル類(PBDE類)</xsl:if>
    <xsl:if test="$id='00046'">ポリ塩化ビフェニル類(PCB類)及び特定代替品</xsl:if>
    <xsl:if test="$id='00047'">ポリ塩化ターフェニル類(PCT類)</xsl:if>
    <xsl:if test="$id='00048'">ポリ塩化ナフタレン類(PCN類)</xsl:if>
    <xsl:if test="$id='00049'">放射性物質</xsl:if>
    <xsl:if test="$id='00050'">耐火セラミック繊維 (RCF)、アルミノ珪酸塩</xsl:if>
    <xsl:if test="$id='00051'">耐火セラミック繊維 (RCF)、ジルコニアアルミノ珪酸塩</xsl:if>
    <xsl:if test="$id='00052'">短鎖型塩化パラフィン類(炭素数10~13)</xsl:if>
    <xsl:if test="$id='00053'">クロム酸ストロンチウム</xsl:if>
    <xsl:if test="$id='00054'">ビス[トリブチルスタンニル]オキシド (TBTO)</xsl:if>
    <xsl:if test="$id='00055'">三置換有機スズ化合物</xsl:if>
    <xsl:if test="$id='00056'">トリス(2-クロロエチル)=ホスファート</xsl:if>
    <xsl:if test="$id='00057'">4-(1,1,3,3-テトラメチルブチル)フェノール</xsl:if>
    <xsl:if test="$id='00058'">ビス(2-メトキシエチル)エーテル</xsl:if>
    <xsl:if test="$id='00059'">ビス(2-メトキシエチル)=フタラート</xsl:if>
    <xsl:if test="$id='00060'">クロム酸八水酸化五亜鉛</xsl:if>
    <xsl:if test="$id='00061'">ヒドロキシオクタオキソ二亜鉛酸二クロム酸カリウム</xsl:if>
    <xsl:if test="$id='00062'">塩素系難燃剤(CFR)</xsl:if>
    <xsl:if test="$id='00063'">塩素系難燃剤(CFR)</xsl:if>
    <xsl:if test="$id='00064'">デカブロモジフェニルエーテル (DecaBDE)</xsl:if>
    <xsl:if test="$id='00065'">亜硫酸と鉛の塩(二塩基性)</xsl:if>
    <xsl:if test="$id='00066'">1,2-ビス(2-メトキシエトキシ)エタン(TEGDME;トリグライム)</xsl:if>
    <xsl:if test="$id='00067'">二酸化ホスホン酸三鉛</xsl:if>
    <xsl:if test="$id='00068'">1,2-ジメトキシエタン;エチレングリコールジメチルエーテル(EGDME)</xsl:if>
    <xsl:if test="$id='00069'">4-アミノアゾベンゼン</xsl:if>
    <xsl:if test="$id='00070'">三酸化硫酸四鉛</xsl:if>
    <xsl:if test="$id='00071'">四酸化三鉛</xsl:if>
    <xsl:if test="$id='00072'">パイロクロア、C.I. ピグメントイエロー41</xsl:if>
    <xsl:if test="$id='00073'">四酸化硫酸五鉛</xsl:if>
    <xsl:if test="$id='00074'">1,2-ジエトキシエタン</xsl:if>
    <xsl:if test="$id='00075'">三酸化二ホウ素</xsl:if>
    <xsl:if test="$id='00076'">ジクロロジブチルスズ(DBTC)</xsl:if>
    <xsl:if test="$id='00077'">シアナミド鉛</xsl:if>
    <xsl:if test="$id='00078'">N,N-ジメチルホルムアミド</xsl:if>
    <xsl:if test="$id='00079'">ケイ酸とバリウムの塩(1:1)(鉛ドープ)</xsl:if>
    <xsl:if test="$id='00080'">ジペンチル(分枝および直鎖)=フタラート</xsl:if>
    <xsl:if test="$id='00081'">ジイソペンチル=フタラート</xsl:if>
    <xsl:if test="$id='00082'">N-ペンチル-イソペンチルフタル酸</xsl:if>
    <xsl:if test="$id='00083'">三酸化チタン鉛</xsl:if>
    <xsl:if test="$id='00084'">チタン酸ジルコニウム酸鉛</xsl:if>
    <xsl:if test="$id='00085'">酸化硫酸二鉛</xsl:if>
    <xsl:if test="$id='00086'">ジオキソ(フタラト)三鉛</xsl:if>
    <xsl:if test="$id='00087'">ジオキソ(ジステアラト)三鉛</xsl:if>
    <xsl:if test="$id='00088'">脂肪酸(C16-C18)と鉛の塩</xsl:if>
    <xsl:if test="$id='00089'">二硝酸鉛</xsl:if>
    <xsl:if test="$id='00090'">フタル酸ジイソデシル(DIDP)</xsl:if>
    <xsl:if test="$id='00091'">フタル酸ジ-n-ヘキシル(DnHP)</xsl:if>
    <xsl:if test="$id='00092'">メチルヘキサヒドロ無水フタル酸</xsl:if>
    <xsl:if test="$id='00093'">カドミウム</xsl:if>
    <xsl:if test="$id='00094'">酸化カドミウム</xsl:if>
    <xsl:if test="$id='00095'">フタル酸ジペンチル、フタル酸ジアミル(DPP)</xsl:if>
    <xsl:if test="$id='00096'">ぺルフルオロオクタン酸(PFOA)</xsl:if>
    <xsl:if test="$id='00097'">ペンタデカフルオロオクタン酸アンモニウム(APFO)</xsl:if>
    <xsl:if test="$id='00098'">4-ノニルフェノール、分岐および直鎖のエトキシレート</xsl:if>
    <xsl:if test="$id='00099'">硫化カドミウム</xsl:if>
    <xsl:if test="$id='00100'">トリス(ジメチルフェニル)=ホスファート</xsl:if>
    <xsl:if test="$id='00102'">3,3&apos;-(ビフェニル-4,4&apos;-ジイルビスアゾ)ビス(4-アミノ-1-ナフタレンスルホン酸ナトリウム)(C.I. ダイレクトレッド 28)</xsl:if>
    <xsl:if test="$id='00103'">ペルフルオロオクタン酸(PFOA)と個々の塩及びPFOAのエステル</xsl:if>
    <xsl:if test="$id='00104'">ペルフルオロオクタン酸(PFOA)と個々の塩及びPFOAのエステル</xsl:if>
    <xsl:if test="$id='00105'">イミダゾリジン-2-チオン(2-イミダゾリン-2-チオール)</xsl:if>
    <xsl:if test="$id='00106'">ジヘキシル(分岐、線型)=フタラート</xsl:if>
    <xsl:if test="$id='00107'">フタル酸ジイソノニル(DINP)</xsl:if>
    <xsl:if test="$id='00108'">ベンゾ[a]ピレン</xsl:if>
    <xsl:if test="$id='00109'">ベンゾ[e]ピレン</xsl:if>
    <xsl:if test="$id='00110'">ベンゾ[a]アントラセン</xsl:if>
    <xsl:if test="$id='00111'">クリセン</xsl:if>
    <xsl:if test="$id='00112'">ベンゾ[b]フルオランテン</xsl:if>
    <xsl:if test="$id='00113'">ベンゾ[j]フルオランテン</xsl:if>
    <xsl:if test="$id='00114'">ベンゾ[k]フルオランテン</xsl:if>
    <xsl:if test="$id='00115'">ジベンゾ[a,h]アントラセン</xsl:if>
    <xsl:if test="$id='00116'">ベンゾ[a]ピレン</xsl:if>
    <xsl:if test="$id='00117'">ベンゾ[e]ピレン</xsl:if>
    <xsl:if test="$id='00118'">ベンゾ[a]アントラセン</xsl:if>
    <xsl:if test="$id='00119'">クリセン</xsl:if>
    <xsl:if test="$id='00120'">ベンゾ[b]フルオランテン</xsl:if>
    <xsl:if test="$id='00121'">ベンゾ[j]フルオランテン</xsl:if>
    <xsl:if test="$id='00122'">ベンゾ[k]フルオランテン</xsl:if>
    <xsl:if test="$id='00123'">ジベンゾ[a,h]アントラセン</xsl:if>
    <xsl:if test="$id='00124'">パーフルオロオクタンスルホン酸塩(PFOS)</xsl:if>
    <xsl:if test="$id='00125'">パーフルオロオクタンスルホン酸塩(PFOS)</xsl:if>
    <xsl:if test="$id='00126'">C.I.ダイレクトブラック38</xsl:if>
    <xsl:if test="$id='00128'">ビス(2-エチルヘキサン-1-イル)=2,2&apos;-[(ジオクタン-1-イルスタンナンジイル)ビス(スルファンジイル)]ジアセタート</xsl:if>
    <xsl:if test="$id='00129'">10-エチル-4,4-ジオクチル-7-オキソ-8-オキサ-3,5-ジチア-4-スタンナテトラデカン酸 2-エチルヘキシルと10-エチル-4-[[2-[(2-エチルヘキシル)オキシ]-2-オキソエチル]チオ]-4-オクチル-7-オキソ-8-オキサ-3,5-ジチア-4-スタンナテトラデカン酸 2-エチルヘキシルを構成要素とする物質 (DOTEとMOTEを構成要素とする物質)</xsl:if>
    <xsl:if test="$id='00130'">2-(2H-ベンゾトリアゾール-2-イル)-4,6-ジ-tert-ペンチルフェノール(UV-328)</xsl:if>
    <xsl:if test="$id='00131'">1,2-ベンゼンジカルボン酸、ジ-C6-10-アルキルエステルまたはデシル、ヘキシル、オクチルジエステルの混合物</xsl:if>
    <xsl:if test="$id='00132'">水銀/水銀化合物</xsl:if>
    <xsl:if test="$id='00133'">1,3-プロパンスルトン</xsl:if>
    <xsl:if test="$id='00134'">2-(2-ヒドロキシ-3,5-ジ-t-ブチルフェニル)-5-クロロベンゾトリアゾール[別名:2-(3,5-ジ-tert-ブチル-2-ヒドロキシフェニル)-5-クロロベンゾトリアゾール]</xsl:if>
    <xsl:if test="$id='00135'">2-(2H-ベンゾトリアゾール-2-イル)-6-sec-ブチル-4-tert-ブチルフェノール</xsl:if>
    <xsl:if test="$id='00137'">パーフルオロノナン-1-酸とそのナトリウム及びアンモニウム塩類</xsl:if>
    <xsl:if test="$id='00138'">ベンゾ[a]ピレン</xsl:if>
    <xsl:if test="$id='00139'">ジシクロヘキサン-1-イル=フタラート</xsl:if>
    <xsl:if test="$id='00140'">パーフルオロノナン-1-酸とそのナトリウム及びアンモニウム塩類</xsl:if>
    <xsl:if test="$id='00141'">4,4&apos;-イソプロピリデンジフェノール(ビスフェノールA)</xsl:if>
    <xsl:if test="$id='00142'">ノナデカフルオロデカン酸(PFDA)およびそのナトリウムとアンモニウム塩</xsl:if>
    <xsl:if test="$id='00143'">ペルフルオロヘキサン-1-スルホン酸及びその塩</xsl:if>
    <xsl:if test="$id='00144'">クリセン</xsl:if>
    <xsl:if test="$id='00145'">ベンゾ[a]アントラセン</xsl:if>
    <xsl:if test="$id='00146'">水酸化カドミウム</xsl:if>
    <xsl:if test="$id='00147'">1,6,7,8,9,14,15,16,17,17,18,18-ドデカクロロペンタシクロ[12.2.1.16,9.02,13.05,10]オクタデカ-7,15-ジエン (デクロランプラス™)</xsl:if>
    <xsl:if test="$id='00148'">ベンゾ[g,h,i]ペリレン</xsl:if>
    <xsl:if test="$id='00149'">2,2,4,4,6,6,8,8-オクタメチルシクロテトラシロキサン</xsl:if>
    <xsl:if test="$id='00150'">2,2,4,4,6,6,8,8,10,10-デカメチルシクロペンタシロキサン</xsl:if>
    <xsl:if test="$id='00151'">2,2,4,4,6,6,8,8,10,10,12,12-ドデカメチルシクロヘキサシロキサン</xsl:if>
    <xsl:if test="$id='00152'">八ホウ酸二ナトリウムアンヒドロ亜酸</xsl:if>
    <xsl:if test="$id='00153'">水素化テルフェニル</xsl:if>
    <xsl:if test="$id='00154'">鉛</xsl:if>
    <xsl:if test="$id='00155'">2,2-ビス(4&apos;-ヒドロキシフェニル)-4-メチルペンタン</xsl:if>
    <xsl:if test="$id='00156'">ベンゾ[k]フルオランテン</xsl:if>
    <xsl:if test="$id='00157'">フルオランテン</xsl:if>
    <xsl:if test="$id='00158'">フェナントレン</xsl:if>
    <xsl:if test="$id='00159'">ピレン</xsl:if>
    <xsl:if test="$id='00160'">ペルフルオロオクタン酸(PFOA)とその塩</xsl:if>
    <xsl:if test="$id='00161'">PFOA関連化合物</xsl:if>
    <xsl:if test="$id='00162'">分岐及び直鎖型4-ノニルフェノールエトキシレートを0.1%以上含む亜リン酸トリス(4-ノニルフェニル、分岐及び直鎖型)(TNPP)</xsl:if>
    <xsl:if test="$id='00163'">七酸化二ナトリウム四ホウ素水和物</xsl:if>
    <xsl:if test="$id='00164'">ジイソヘキシル=フタラート</xsl:if>
    <xsl:if test="$id='00165'">パーフルオロブタンスルホン酸 (PFBS) とその塩</xsl:if>
    <xsl:if test="$id='00166'">カドミウム/カドミウム化合物</xsl:if>
    <xsl:if test="$id='00167'">六価クロム化合物</xsl:if>
    <xsl:if test="$id='00168'">鉛/鉛化合物</xsl:if>
    <xsl:if test="$id='00169'">水銀/水銀化合物</xsl:if>
    <xsl:if test="$id='00170'">スズ, ジブチルビス(2,4-ペンタンジオナト-O,O&apos;)-, (OC-6-11)-</xsl:if>
    <xsl:if test="$id='00171'">ハロゲン系難燃剤</xsl:if>
    <xsl:if test="$id='00172'">テトラエチレングリコールジメチルエーテル</xsl:if>
    <xsl:if test="$id='00173'">ジオクチルビス[(1-オキソドデシル)オキシ]スズ、スタンナン, ジオクチル-, ビス(ココアシルオキシ)誘導体及びその他の全てのスタンナン, ジオクチル-, ビス(脂肪族アシルオキシ)誘導体ただし脂肪族アシルオキシ部分の炭素数が主にC12であるもの</xsl:if>
    <xsl:if test="$id='00174'">リン酸イソプロピルフェニル</xsl:if>
    <xsl:if test="$id='00175'">コバルト/コバルト化合物</xsl:if>
    <xsl:if test="$id='00176'">ネオジム/ネオジム化合物</xsl:if>
    <xsl:if test="$id='00177'">4,4&apos;-(1-メチルプロピリデン)ビスフェノール</xsl:if>
    <xsl:if test="$id='00178'">中鎖塩素化パラフィン(MCCP)</xsl:if>
    <xsl:if test="$id='00179'">ホウ酸のナトリウム塩</xsl:if>
	</xsl:template>

<!--
##########################################################################################
		物質用途
##########################################################################################-->
  <xsl:template name="getSubstanceApp">
    <xsl:param name="id" />
    <xsl:if test="$id='00001'">全製品</xsl:if>
    <xsl:if test="$id='00002'">全製品</xsl:if>
    <xsl:if test="$id='00003'">全製品</xsl:if>
    <xsl:if test="$id='00004'">織物/皮革製品</xsl:if>
    <xsl:if test="$id='00005'">全製品</xsl:if>
    <xsl:if test="$id='00007'">全製品</xsl:if>
    <xsl:if test="$id='00008'">積層プリント配線基板</xsl:if>
    <xsl:if test="$id='00009'">積層プリント配線基板を除くプラスチック材料</xsl:if>
    <xsl:if test="$id='00010'">電池を除く全製品</xsl:if>
    <xsl:if test="$id='00011'">電池</xsl:if>
    <xsl:if test="$id='00012'">全製品</xsl:if>
    <xsl:if test="$id='00013'">全製品</xsl:if>
    <xsl:if test="$id='00014'">全製品</xsl:if>
    <xsl:if test="$id='00015'">(a)皮膚と接触することを意図する織物/皮革製品 (b)育児製品 (c)2液性室温硬化モールディングキット(RTV-2シーラントモールディングキット)</xsl:if>
    <xsl:if test="$id='00016'">全製品</xsl:if>
    <xsl:if test="$id='00017'">全製品</xsl:if>
    <xsl:if test="$id='00018'">全製品</xsl:if>
    <xsl:if test="$id='00019'">織物</xsl:if>
    <xsl:if test="$id='00020'">全製品</xsl:if>
    <xsl:if test="$id='00021'">電池を除く全製品</xsl:if>
    <xsl:if test="$id='00022'">主として12歳以下の子供向けの消費者製品</xsl:if>
    <xsl:if test="$id='00023'">子供向けの玩具及び製品の塗料又は表面塗装</xsl:if>
    <xsl:if test="$id='00024'">熱硬化性/熱可塑性樹脂で被覆された電線・ケーブル又はコード</xsl:if>
    <xsl:if test="$id='00025'">電池</xsl:if>
    <xsl:if test="$id='00026'">全製品</xsl:if>
    <xsl:if test="$id='00027'">全製品</xsl:if>
    <xsl:if test="$id='00028'">全製品</xsl:if>
    <xsl:if test="$id='00029'">電池を除く全製品</xsl:if>
    <xsl:if test="$id='00030'">電池</xsl:if>
    <xsl:if test="$id='00031'">長期間皮膚に接触する可能性のある製品</xsl:if>
    <xsl:if test="$id='00032'">全製品</xsl:if>
    <xsl:if test="$id='00033'">全製品</xsl:if>
    <xsl:if test="$id='00035'">全製品</xsl:if>
    <xsl:if test="$id='00036'">玩具、または育児製品</xsl:if>
    <xsl:if test="$id='00037'">子供の口に入る玩具、または育児製品</xsl:if>
    <xsl:if test="$id='00038'">全製品</xsl:if>
    <xsl:if test="$id='00039'">全製品</xsl:if>
    <xsl:if test="$id='00040'">全製品</xsl:if>
    <xsl:if test="$id='00041'">全製品</xsl:if>
    <xsl:if test="$id='00042'">全製品</xsl:if>
    <xsl:if test="$id='00043'">全製品</xsl:if>
    <xsl:if test="$id='00044'">全製品</xsl:if>
    <xsl:if test="$id='00045'">全製品</xsl:if>
    <xsl:if test="$id='00046'">全製品</xsl:if>
    <xsl:if test="$id='00047'">全製品</xsl:if>
    <xsl:if test="$id='00048'">全製品</xsl:if>
    <xsl:if test="$id='00049'">全製品</xsl:if>
    <xsl:if test="$id='00050'">全製品</xsl:if>
    <xsl:if test="$id='00051'">全製品</xsl:if>
    <xsl:if test="$id='00052'">全製品</xsl:if>
    <xsl:if test="$id='00053'">全製品</xsl:if>
    <xsl:if test="$id='00054'">全製品</xsl:if>
    <xsl:if test="$id='00055'">全製品</xsl:if>
    <xsl:if test="$id='00056'">全製品</xsl:if>
    <xsl:if test="$id='00057'">全製品</xsl:if>
    <xsl:if test="$id='00058'">全製品</xsl:if>
    <xsl:if test="$id='00059'">全製品</xsl:if>
    <xsl:if test="$id='00060'">全製品</xsl:if>
    <xsl:if test="$id='00061'">全製品</xsl:if>
    <xsl:if test="$id='00062'">積層プリント配線基板を除くプラスチック材料</xsl:if>
    <xsl:if test="$id='00063'">積層プリント配線基板</xsl:if>
    <xsl:if test="$id='00064'">全製品</xsl:if>
    <xsl:if test="$id='00065'">全製品</xsl:if>
    <xsl:if test="$id='00066'">全製品</xsl:if>
    <xsl:if test="$id='00067'">全製品</xsl:if>
    <xsl:if test="$id='00068'">全製品</xsl:if>
    <xsl:if test="$id='00069'">全製品</xsl:if>
    <xsl:if test="$id='00070'">全製品</xsl:if>
    <xsl:if test="$id='00071'">全製品</xsl:if>
    <xsl:if test="$id='00072'">全製品</xsl:if>
    <xsl:if test="$id='00073'">全製品</xsl:if>
    <xsl:if test="$id='00074'">全製品</xsl:if>
    <xsl:if test="$id='00075'">全製品</xsl:if>
    <xsl:if test="$id='00076'">全製品</xsl:if>
    <xsl:if test="$id='00077'">全製品</xsl:if>
    <xsl:if test="$id='00078'">全製品</xsl:if>
    <xsl:if test="$id='00079'">全製品</xsl:if>
    <xsl:if test="$id='00080'">全製品</xsl:if>
    <xsl:if test="$id='00081'">全製品</xsl:if>
    <xsl:if test="$id='00082'">全製品</xsl:if>
    <xsl:if test="$id='00083'">全製品</xsl:if>
    <xsl:if test="$id='00084'">全製品</xsl:if>
    <xsl:if test="$id='00085'">全製品</xsl:if>
    <xsl:if test="$id='00086'">全製品</xsl:if>
    <xsl:if test="$id='00087'">全製品</xsl:if>
    <xsl:if test="$id='00088'">全製品</xsl:if>
    <xsl:if test="$id='00089'">全製品</xsl:if>
    <xsl:if test="$id='00090'">全製品</xsl:if>
    <xsl:if test="$id='00091'">全製品</xsl:if>
    <xsl:if test="$id='00092'">全製品</xsl:if>
    <xsl:if test="$id='00093'">全製品</xsl:if>
    <xsl:if test="$id='00094'">全製品</xsl:if>
    <xsl:if test="$id='00095'">全製品</xsl:if>
    <xsl:if test="$id='00096'">全製品</xsl:if>
    <xsl:if test="$id='00097'">全製品</xsl:if>
    <xsl:if test="$id='00098'">全製品</xsl:if>
    <xsl:if test="$id='00099'">全製品</xsl:if>
    <xsl:if test="$id='00100'">全製品</xsl:if>
    <xsl:if test="$id='00102'">全製品</xsl:if>
    <xsl:if test="$id='00103'">織物および、フィルムまたは紙または印刷用原版用の写真コーティングおよびその他のコートされた消費者製品</xsl:if>
    <xsl:if test="$id='00104'">織物および、フィルムまたは紙または印刷用原版用の写真コーティングおよびその他のコートされた消費者製品を除く全製品</xsl:if>
    <xsl:if test="$id='00105'">全製品</xsl:if>
    <xsl:if test="$id='00106'">全製品</xsl:if>
    <xsl:if test="$id='00107'">全製品</xsl:if>
    <xsl:if test="$id='00108'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00109'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00110'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00111'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00112'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00113'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00114'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00115'">玩具と育児製品を除き、直接かつ長期間または反復して皮膚または口腔接触するゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00116'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00117'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00118'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00119'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00120'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00121'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00122'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00123'">直接かつ長期間または反復して皮膚または口腔接触する玩具と育児製品のゴムまたはプラスチック部分</xsl:if>
    <xsl:if test="$id='00124'">織物またはその他のコートされた材料</xsl:if>
    <xsl:if test="$id='00125'">織物とその他のコートされた材料を除く全製品</xsl:if>
    <xsl:if test="$id='00126'">全製品</xsl:if>
    <xsl:if test="$id='00128'">全製品</xsl:if>
    <xsl:if test="$id='00129'">全製品</xsl:if>
    <xsl:if test="$id='00130'">全製品</xsl:if>
    <xsl:if test="$id='00131'">全製品</xsl:if>
    <xsl:if test="$id='00132'">電池</xsl:if>
    <xsl:if test="$id='00133'">全製品</xsl:if>
    <xsl:if test="$id='00134'">全製品</xsl:if>
    <xsl:if test="$id='00135'">全製品</xsl:if>
    <xsl:if test="$id='00137'">全製品</xsl:if>
    <xsl:if test="$id='00138'">全製品</xsl:if>
    <xsl:if test="$id='00139'">全製品</xsl:if>
    <xsl:if test="$id='00140'">全製品</xsl:if>
    <xsl:if test="$id='00141'">全製品</xsl:if>
    <xsl:if test="$id='00142'">全製品</xsl:if>
    <xsl:if test="$id='00143'">全製品</xsl:if>
    <xsl:if test="$id='00144'">全製品</xsl:if>
    <xsl:if test="$id='00145'">全製品</xsl:if>
    <xsl:if test="$id='00146'">全製品</xsl:if>
    <xsl:if test="$id='00147'">全製品</xsl:if>
    <xsl:if test="$id='00148'">全製品</xsl:if>
    <xsl:if test="$id='00149'">全製品</xsl:if>
    <xsl:if test="$id='00150'">全製品</xsl:if>
    <xsl:if test="$id='00151'">全製品</xsl:if>
    <xsl:if test="$id='00152'">全製品</xsl:if>
    <xsl:if test="$id='00153'">全製品</xsl:if>
    <xsl:if test="$id='00154'">全製品</xsl:if>
    <xsl:if test="$id='00155'">全製品</xsl:if>
    <xsl:if test="$id='00156'">全製品</xsl:if>
    <xsl:if test="$id='00157'">全製品</xsl:if>
    <xsl:if test="$id='00158'">全製品</xsl:if>
    <xsl:if test="$id='00159'">全製品</xsl:if>
    <xsl:if test="$id='00160'">全製品</xsl:if>
    <xsl:if test="$id='00161'">全製品</xsl:if>
    <xsl:if test="$id='00162'">全製品</xsl:if>
    <xsl:if test="$id='00163'">全製品</xsl:if>
    <xsl:if test="$id='00164'">全製品</xsl:if>
    <xsl:if test="$id='00165'">全製品</xsl:if>
    <xsl:if test="$id='00166'">4インチ以上のスクリーンを含むビデオディスプレイ</xsl:if>
    <xsl:if test="$id='00167'">4インチ以上のスクリーンを含むビデオディスプレイ</xsl:if>
    <xsl:if test="$id='00168'">4インチ以上のスクリーンを含むビデオディスプレイ</xsl:if>
    <xsl:if test="$id='00169'">4インチ以上のスクリーンを含むビデオディスプレイ</xsl:if>
    <xsl:if test="$id='00170'">全製品</xsl:if>
    <xsl:if test="$id='00171'">100cm^2超のスクリーンを有するテレビ、モニター及びデジタルサイネージディスプレイを含む電子ディスプレイの筐体及びスタンド</xsl:if>
    <xsl:if test="$id='00172'">全製品</xsl:if>
    <xsl:if test="$id='00173'">全製品</xsl:if>
    <xsl:if test="$id='00174'">全製品</xsl:if>
    <xsl:if test="$id='00175'">コンピュータサーバー及びオンラインデータストレージ製品に使用される電池</xsl:if>
    <xsl:if test="$id='00176'">コンピュータサーバー及びオンラインデータストレージ製品に使用されるHDD</xsl:if>
    <xsl:if test="$id='00177'">全製品</xsl:if>
    <xsl:if test="$id='00178'">全製品</xsl:if>
    <xsl:if test="$id='00179'">全製品</xsl:if>
  </xsl:template>

<!--
##########################################################################################
		物質閾値
##########################################################################################-->
  <xsl:template name="getSubstanceThreshold">
    <xsl:param name="id" />
    <xsl:if test="$id='00001'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00002'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00003'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00004'">生成アミンが仕上がり織物/皮革製品の0.003重量%(30ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00005'">0.1重量%(1000ppm) [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00007'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00008'">基板中の臭素の含有合計で0.09重量%(900ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00009'">プラスチック材料中の臭素として0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00010'">均質材料中のカドミウムの0.01重量%(100ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00011'">電池中のカドミウムの0.001重量%(10ppm) [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00012'">均質材料中の六価クロムの0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00013'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00014'">部品中のスズの0.1重量%(1000ppm) [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00015'">部品中のスズの0.1重量%(1000ppm) [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00016'">部品中の0.00001重量%(0.1ppm) [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00017'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00018'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00019'">織物製品の0.0075重量%(75ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00020'">意図的添加または0.01重量%(100ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00021'">均質材料中の鉛の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00022'">製品中の鉛の0.01重量%(100ppm) [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00023'">表面塗装中の鉛の0.009重量%(90ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00024'">表面被覆材中の鉛の0.03重量%(300ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00025'">電池中の鉛の0.004重量%(40ppm) [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00026'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00027'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00028'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00029'">意図的添加または均質材料の水銀の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00030'">意図的添加または電池中の水銀の0.0001重量%(1ppm) [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00031'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00032'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00033'">電池または構成部品の6E-7重量% [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00035'">意図的添加または0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00036'">フタル酸エステルの合計として可塑化した材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00037'">フタル酸エステルの合計として可塑化した材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00038'">均質材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00039'">均質材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00040'">均質材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00041'">均質材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00042'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00043'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00044'">均質材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00045'">均質材料の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00046'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00047'">材料の0.005重量% [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00048'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00049'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00050'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00051'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00052'">意図的添加または0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00053'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00054'">意図的添加または0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00055'">意図的添加またはスズ元素としての、部品中の0.1重量% [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00056'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00057'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00058'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00059'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00060'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00061'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00062'">プラスチック材料中の塩素の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00063'">基板中塩素の含有合計で0.09重量%(900ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00064'">意図的添加または0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00065'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00066'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00067'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00068'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00069'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00070'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00071'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00072'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00073'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00074'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00075'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00076'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00077'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00078'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00079'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00080'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00081'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00082'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00083'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00084'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00085'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00086'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00087'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00088'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00089'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00090'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00091'">意図的添加または0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00092'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00093'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00094'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00095'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00096'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00097'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00098'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00099'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00100'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00102'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00103'">1μg/m2(PFOAの合計として) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00104'">部品中0.1%(PFOAの合計として) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00105'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00106'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00107'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00108'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00109'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00110'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00111'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00112'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00113'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00114'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00115'">プラスチックまたはゴム部品の0.0001重量%(1ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00116'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00117'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00118'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00119'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00120'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00121'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00122'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00123'">プラスチックまたはゴム部品の0.00005重量%(0.5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00124'">意図的添加またはコートされた材料の1μg/m2 [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00125'">意図的添加または部品中の0.1重量%(1000ppm)(PFOSの合計として) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00126'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00128'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00129'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00130'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00131'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00132'">均質材料中の水銀の0.0005重量%(5ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00133'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00134'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00135'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00137'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00138'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00139'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00140'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00141'">意図的添加または0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00142'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00143'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00144'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00145'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00146'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00147'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00148'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00149'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00150'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00151'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00152'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00153'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00154'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00155'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00156'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00157'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00158'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00159'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00160'">PFOA とその塩の合計で成形品や混合物中の0.0000025 重量% [報告レベル:成形品、混合物]</xsl:if>
    <xsl:if test="$id='00161'">PFOA関連化合物またはそれらの組み合わせで成形品や混合物中の0.0001重量% [報告レベル:成形品、混合物]</xsl:if>
    <xsl:if test="$id='00162'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00163'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00164'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00165'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00166'">均質材料中のカドミウムの0.01重量%(100ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00167'">均質材料中の六価クロムの0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00168'">均質材料中の鉛の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00169'">均質材料中の水銀の0.1重量%(1000ppm) [報告レベル:材料]</xsl:if>
    <xsl:if test="$id='00170'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00171'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00172'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00173'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00174'">意図的添加 [報告レベル:製品]</xsl:if>
    <xsl:if test="$id='00175'">意図的添加 [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00176'">意図的添加 [報告レベル:部品]</xsl:if>
    <xsl:if test="$id='00177'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00178'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
    <xsl:if test="$id='00179'">0.1重量%(1000ppm) [報告レベル:成形品]</xsl:if>
  </xsl:template>

</xsl:stylesheet>