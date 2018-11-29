﻿{include file='user/main.tpl'}

<script src="//cdn.jsdelivr.net/gh/YihanH/canvasjs.js@v2.2/canvasjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.3.1"></script>
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>

{function displayV2rayNode node=null}
	{assign var=server_explode value=";"|explode:$node['server']}
	<div class="tiptitle">
		<a href="javascript:void(0);">{$node['name']}</a>
	</div>

	<p>地址：<span class="label label-brand-accent">
												{$server_explode[0]}
											</span></p>

	<p>端口：<span class="label label-brand-red">
												{$server_explode[1]}
											</span></p>

	<p>协议参数：<span class="label label-green">
												{$server_explode[0]}
											</span></p>

	<p>用户 UUID：<span class="label label-brand">
												{$user->getUuid()}
											</span></p>

	<p>流量比例：<span class="label label-red">
												{$node['traffic_rate']}
											</span></p>

	<p>AlterId：<span class="label label-green">
												{$server_explode[2]}
											</span></p>

	<p>VMess链接：
		<a class="copy-text" data-clipboard-text="{URL::getV2Url($user, $node['raw_node'])}">点击复制</a>
	</p>
{/function}

<main class="content">
	<div class="content-header ui-content-header">
		<div class="container">
			<h1 class="content-heading">节点列表</h1>
		</div>
	</div>

	<div class="container">
		<section class="content-inner margin-top-no">
			<div class="ui-card-wrap">
				<div class="row">
					<div class="col-lg-12 col-sm-12 nodelist">
							
							<div class="ui-switch node-switch">
								<div class="card">
									<div class="card-main">
										<div class="card-inner ui-switch">
											<div class="switch-btn" id="switch-cards"><a href="#" onclick="return false"><i class="mdui-icon material-icons">apps</i></a></div>
											<div class="switch-btn" id="switch-table"><a href="#" onclick="return false"><i class="mdui-icon material-icons">dehaze</i></a></div>
										</div>
									</div>
								</div>
							</div>
						
                    <div class="node-cardgroup">
                        {$class=-1}
						{foreach $nodes as $node}
						{if $node['class']!=$class}
							{$class=$node['class']}
							{if !$node@first}</div>{/if}
							<div class="nodetitle">
								<a class="waves-effect waves-button" data-toggle="collapse" href="#cardgroup{$class}" aria-expanded="true" aria-controls="cardgroup{$class}">
								    <span>{if $class == 0}普通{else}VIP {$node['class']} {/if}用户节点</span><i class="material-icons">expand_more</i>
								</a>
							</div>
							<div class="card-row collapse in" id="cardgroup{$class}">
						{/if}
						<div class="node-card node-flex" cardindex="{$node@index}">
                            <div class="nodemain">
                                <div class="nodehead node-flex">
                                    {if $config['enable_flag']=='true'}<div class="flag"><img src="/images/prefix/{$node['flag']}" alt=""></div>{/if}
                                    <div class="nodename">{$node['name']}</div>
                                </div>
                                <div class="nodemiddle node-flex">
                                    <div class="onlinemember node-flex"><i class="material-icons node-icon">flight_takeoff</i><span>{if $node['online_user'] == -1} N/A{else} {$node['online_user']}{/if}</span></div>
                                    <div class="nodetype">{$node['status']}</div>
                                </div>
                                <div class="nodeinfo node-flex">
                                    <div class="nodetraffic node-flex"><i class="material-icons node-icon">equalizer</i><span>{if $node['traffic_limit']>0}{$node['traffic_used']}/{$node['traffic_limit']}GB{else}{$node['traffic_used']}GB{/if}</span></div>
                                    <div class="nodecheck node-flex">
                                        <i class="material-icons node-icon">network_check</i><span>x{$node['traffic_rate']}</span>
                                    </div>
                                    <div class="nodeband node-flex"><i class="material-icons node-icon">flash_on</i><span>{if {$node['bandwidth']}==0}N/A{else}{$node['bandwidth']}{/if}</span></div>
                                </div>
                            </div>
                            <div class="nodestatus">
                                <div class="{if $node['online']=="1"}nodeonline{elseif $node['online']=='0'}nodeunset{else}nodeoffline{/if}">
                                    <i class="material-icons">{if $node['online']=="1"}cloud_queue{elseif $node['online']=='0'}wifi_off{else}flash_off{/if}</i>
                                </div>
							</div>

						</div>
						<div class="node-tip cust-model" tipindex="{$node@index}">
								{if $node['class'] > $user->class}
									<p class="card-heading" align="center"><b> <i class="icon icon-lg">visibility_off</i>
										您当前等级不足以使用该节点，如需升级请<a href="/user/shop">点击这里</a>升级套餐</b></p>
								{else}

									{$relay_rule = null}

                                    {if $node['sort'] == 10 && $node['sort'] != 11}
										{$relay_rule = $tools->pick_out_relay_rule($node['id'], $user->port, $relay_rules)}
									{/if}

									{if $node['mu_only'] != 1}
									    <div class="tiptitle">
											<a href="javascript:void(0);" onClick="urlChange('{$node['id']}',0,{if $relay_rule != null}{$relay_rule->id}{else}0{/if})">{$node['name']}
												{if $relay_rule != null} - {$relay_rule->dist_node()->name}{/if}</a>
												<div class="nodeload">
													<div class="label label-brand-accent"> ↑点击节点查看配置信息</div>
												<div>
													<span class="node-icon"><i class="icon icon-lg">cloud</i></span>
													<span class="node-load">负载：<code>{if $node['latest_load'] == -1}N/A{else}{$node['latest_load']}%{/if}</code></span>
												</div>
											</div>
										</div>
									{/if}

									{if $node['sort'] == 0 || $node['sort'] == 10}
										{$point_node=$node}
									{/if}

									{if ($node['sort'] == 0 || $node['sort'] == 10) && $node['mu_only'] != -1}
										{foreach $nodes_muport as $single_muport}

										{if !($single_muport['server']->node_class <= $user->class && ($single_muport['server']->node_group == 0 || $single_muport['server']->node_group == $user->node_group))}
											{continue}
										{/if}

										{if !($single_muport['user']->class >= $node['class'] && ($node['group'] == 0 || $single_muport['user']->node_group == $node['group']))}
											{continue}
										{/if}

										{$relay_rule = null}

										{if $node['sort'] == 10 && $single_muport['user']['is_multi_user'] != 2}
											{$relay_rule = $tools->pick_out_relay_rule($node['id'], $single_muport['server']->server, $relay_rules)}
										{/if}
										<div class="tiptitle">
												<a href="javascript:void(0);" onClick="urlChange('{$node['id']}',{$single_muport['server']->server},{if $relay_rule != null}{$relay_rule->id}{else}0{/if})">{$node['name']}
													{if $relay_rule != null} - {$relay_rule->dist_node()->name}{/if} - 单端口 Shadowsocks -
													{$single_muport['server']->server} 端口</a>
												</div>
										{/foreach}
									{/if}
									<div class="tipmiddle">
										<div><span class="node-icon"><i class="icon icon-lg">chat</i> </span>{$node['info']}</div>
									</div>


									{if $node['sort'] == 11}
										{displayV2rayNode node=$node}
									{/if}


								{/if}
							</div>
						{$point_node=null}
						{if $node@last}</div>{/if}
						{/foreach}
					</div>

					<div class="card node-table">
							<div class="card-main">
								<div class="card-inner margin-bottom-no">
									<div class="tile-wrap">        
										{$class=-1}
										{foreach $nodes as $node}
                                        
										{if $node['class']!=$class}
											{$class=$node['class']}
											
											<p class="card-heading">{if $class == 0}普通{else}VIP {$node['class']} {/if}用户节点</p>	
										{/if}

										<div class="tile tile-collapse">
											<div data-toggle="tile" data-target="#heading{$node['id']}">
												<div class="tile-side pull-left" data-ignore="tile">
													<div class="avatar avatar-sm">
														<span class="icon {if $node['online']=='1'}text-green
																			 {elseif $node['online']=='0'}text-orange
																			    {else}text-red
																				    {/if}">
															{if $node['online']=="1"}backup
																{elseif $node['online']=='0'}report
																	{else}warning
																	    {/if}
														</span>
													</div>
												</div>
												<div class="tile-inner">
													<div class="text-overflow node-textcolor">
														<span class="enable-flag">
															{if $config['enable_flag']=='true'}
															   <img src="/images/prefix/{$node['flag']}" height="22" width="40" />
															{/if}
															   {$node['name']}
														</span>
														| {if $user->class!=0}
														<span class="node-icon"><i class="icon icon-lg">flight_takeoff</i></span>
														  {else}
														  {/if} 
														  <strong><b><span class="node-alive">{if $node['online_user'] == -1}N/A{else}{$node['online_user']}{/if}</span></b></strong> 
											            | <span class="node-icon"><i class="icon icon-lg">cloud</i></span>
														<span class="node-load">负载：{if $node['latest_load'] == -1}N/A{else}{$node['latest_load']}%{/if}</span> 
														| <span class="node-icon"><i class="icon icon-lg">import_export</i></span>
														<span class="node-mothed">{$node['bandwidth']}</span> 
														| <span class="node-icon"><i class="icon icon-lg">equalizer</i></span>
														{if $node['traffic_limit']>0}
															<span class="node-band">{$node['traffic_used']}/{$node['traffic_limit']}</span>
														{else}
															{$node['traffic_used']}GB
														{/if}
														| <span class="node-icon"><i class="icon icon-lg">network_check</i></span>
														<span class="node-tr">{$node['traffic_rate']} 倍率</span> 
														| <span class="node-icon"><i class="icon icon-lg">notifications_none</i></span>
														<span class="node-status">{$node['status']}</span>
													</div>
												</div>
											</div>

										    <div class="collapsible-region collapse" id="heading{$node['id']}">
												<div class="tile-sub">
													<br>
                                                {if $node['class'] > $user->class}
													<div class="card">
														<div class="card-main">
															<div class="card-inner">
																<p class="card-heading" align="center"><b> <i class="icon icon-lg">visibility_off</i>
																		您当前等级不足以使用该节点，如需升级请<a href="/user/shop">点击这里</a>升级套餐</b></p>
															</div>
														</div>
													</div>
													{else}

													{$relay_rule = null}
													<!-- 用户等级不小于节点等级 -->

                                                    {if $node['sort'] == 10 && $node['sort'] != 11}
													{$relay_rule = $tools->pick_out_relay_rule($node['id'], $user->port, $relay_rules)}
													{/if}
                                                 <div class="card nodetip-table">
														<div class="card-main">
																<div class="card-inner">
													{if $node['mu_only'] != 1}
													
																<p class="card-heading">
																	<a href="javascript:void(0);" onClick="urlChange('{$node['id']}',0,{if $relay_rule != null}{$relay_rule->id}{else}0{/if})">{$node['name']}
																		{if $relay_rule != null} - {$relay_rule->dist_node()->name}{/if}</a>
																	<span class="label label-brand-accent">←点击节点查看配置信息</span>
																</p>
														
												    {/if}

                                                    {if $node['sort'] == 0 || $node['sort'] == 10}
													{$point_node=$node}
													{/if}

													{if ($node['sort'] == 0 || $node['sort'] == 10) && $node['mu_only'] != -1}
													{foreach $nodes_muport as $single_muport}

													{if !($single_muport['server']->node_class <= $user->class && ($single_muport['server']->node_group == 0 || $single_muport['server']->node_group == $user->node_group))}
														{continue}
													{/if}

													{if !($single_muport['user']->class >= $node['class'] && ($node['group'] == 0 || $single_muport['user']->node_group == $node['group']))}
														{continue}
													{/if}

													{$relay_rule = null}

													{if $node['sort'] == 10 && $single_muport['user']['is_multi_user'] != 2}
														{$relay_rule = $tools->pick_out_relay_rule($node['id'], $single_muport['server']->server, $relay_rules)}
													{/if}

														
																	<p class="card-heading">
																		<a href="javascript:void(0);" onClick="urlChange('{$node['id']}',{$single_muport['server']->server},{if $relay_rule != null}{$relay_rule->id}{else}0{/if})">{$node['name']}
																			{if $relay_rule != null} - {$relay_rule->dist_node()->name}{/if} - 单端口 Shadowsocks -
																			{$single_muport['server']->server} 端口</a><span class="label label-brand-accent">←点击节点查看配置信息</span>
																	</p>
																	
												

													{/foreach}
													{/if}
													
													<div><i class="icon icon-lg node-icon">chat</i> {$node['info']}</div>

													{if $node['sort'] == 11}
														{displayV2rayNode node=$node}
													{/if}
												</div>
											  </div>

										    </div>
											{/if}
											   
												{if isset($point_node)}
												{if $point_node!=null}
		
												<div class="card">
													<div class="card-main">
														<div class="card-inner" id="info{$node@index}">
		
														</div>
													</div>
												</div>
		
												<script>
													$().ready(function () {
														$('#heading{$node['id']}').on("shown.bs.tile", function () {
															$("#info{$node@index}").load("/user/node/{$point_node['id']}/ajax");
														});
													});
												</script>
												{/if}
												{/if}
											
                                                </div>
											</div>

										

										{$point_node=null}
								
										</div>
										{/foreach}
										
										

									</div>
								</div>
							</div>
						</div>
					</div>

					{include file='dialog.tpl'}
					<div aria-hidden="true" class="modal modal-va-middle fade" id="nodeinfo" role="dialog" tabindex="-1">
						<div class="modal-dialog modal-full">
							<div class="modal-content">
								<iframe class="iframe-seamless" title="Modal with iFrame" id="infoifram"></iframe>
							</div>
						</div>
					</div>
		</section>
	</div>
</main>







{include file='user/footer.tpl'}


<script>

	function urlChange(id, is_mu, rule_id) {
		var site = './node/' + id + '?ismu=' + is_mu + '&relay_rule=' + rule_id;
		if (id == 'guide') {
			var doc = document.getElementById('infoifram').contentWindow.document;
			doc.open();
			doc.write('<img src="../images/node.gif" style="width: 100%;height: 100%; border: none;"/>');
			doc.close();
		}
		else {
			document.getElementById('infoifram').src = site;
		}
		$("#nodeinfo").modal();
	}

	$(function () {
		new Clipboard('.copy-text');
	});
	$(".copy-text").click(function () {
		$("#result").modal();
		$("#msg").html("已复制，请进入软件添加。");
	});

	{literal}
    ;(function(){
		'use strict'
	
	$('a[href^="#cardgroup"]').click(function(){
		var rotatearrow = $(this).find('i');
		if (!rotatearrow.hasClass('arrow-rotate')) {
			rotatearrow.addClass('arrow-rotate');
		} else {		
			rotatearrow.removeClass('arrow-rotate');
		}
	});

	var nodeDefaultUI = localStorage.getItem("tempUInode");
	var elNodeCard = $(".node-cardgroup");
	var elNodeTable = $(".node-table");
	nodeDefaultUI = JSON.parse(nodeDefaultUI);
	if (!nodeDefaultUI) {
		elNodeTable.css("display","flex");
	} else {
		elNodeCard.css("display",nodeDefaultUI["cardDisplay"]);
	    elNodeCard.removeClass("node-fade").addClass(nodeDefaultUI["cardFade"]);
	    elNodeTable.css("display",nodeDefaultUI["tableDisplay"]);
	    elNodeTable.removeClass("node-fade").addClass(nodeDefaultUI["tableFade"]);
	}
	

	$("#switch-cards").click(function (){
        elNodeTable.addClass("node-fade");
		setTimeout(function(){
		      elNodeCard.css("display","grid");
              elNodeTable.css("display","none");
		},250);	
		setTimeout(function(){
		      elNodeCard.removeClass("node-fade");
		},270);
		var defaultUI = {
			"cardFade":"",
			"cardDisplay":"grid",
			"tableFade":"node-fade",
			"tableDisplay":"none"
		};
		defaultUI = JSON.stringify(defaultUI);
		localStorage.setItem("tempUInode",defaultUI);
    });

    $("#switch-table").click(function (){
         elNodeCard.addClass("node-fade");
		 setTimeout(function(){
			elNodeTable.css("display","flex");
              elNodeCard.css("display","none");
		},250);	
		 setTimeout(function(){
			  elNodeTable.removeClass("node-fade");
	    },270);
		var defaultUI = {
			"cardFade":"node-fade",
			"cardDisplay":"none",
			"tableFade":"",
			"tableDisplay":"flex"
		};
		defaultUI = JSON.stringify(defaultUI);
		localStorage.setItem("tempUInode",defaultUI);
	});
	
	let buttongroup = document.querySelectorAll('.node-card');
	let modelgroup = document.querySelectorAll('.node-tip');
	for (let i=0;i<buttongroup.length;i++) {
		custModal(buttongroup[i],modelgroup[i]);
	}

	// var tipHidden = $(".tiphidden");
	// $(".node-card").click(function (){
	// 	var windowWidth = $(window).width();
	// 	var cardSize = $(this).css("grid-column-end");
	// 	var tipID = $(this).attr("cardindex");
	// 	var tip = $(".node-tip[tipindex=" + tipID + "]");
	// 	tipHidden.css({"height":"100vh","width":"100vw"});
	// 	tip.css("z-index","3");
	// 	setTimeout(function() {
    //        tip.addClass("tip-down");
	// 	},200);
    // });

	// tipHidden.click(function(){
    //     tipHidden.css({"height":"0","width":"0"});
	// 	$(".node-tip.tip-down").removeClass("tip-down");
	// 	var hiddenOver = setTimeout(function(){
	// 		$(".node-tip").css("z-index","-1");
	// 	},520);
	// 	clearTimeout(hiddenOver);
	// });

    })();
	{/literal}
 
</script>