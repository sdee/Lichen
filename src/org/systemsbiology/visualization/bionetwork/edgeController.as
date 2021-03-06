package org.systemsbiology.visualization.bionetwork
{
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.render.ArrowType;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.BundledEdgeRouter;
	import flare.query.methods.div;
	import flare.vis.data.Data;
	
	import org.systemsbiology.visualization.bionetwork.data.Network;
	import org.systemsbiology.visualization.bionetwork.display.MultiEdgeRenderer;

	
	public class edgeController
	{

		
		public function edgeController()
		{
			
		}
		
		public static function styleEdges(network : Network, options : Object):void{
			//basic options and defaults
			network.data.edges.setProperties({			
					lineWidth: options.edge_lineWidth || 2,
					lineColor: options.edge_lineColor || 0x66000000,
					buttonMode: true 
				});
			
			//directed edges are special case
			network.data.edges.setProperties({
				arrowType: ArrowType.TRIANGLE,
				arrowWidth: 15,
				arrowHeight: 15
				}, null, function(e:EdgeSprite):Boolean{return e.directed==true;});
			
			//delegate to edgeRenderers
			if (options['edgeRenderer']=='multiedge'){
				multiEdge(network,options);
			}
			
			if(options['edge_router']=='bundled')
			{
				bundledEdge(network,options);
			}
			
			
			
		}
		
		public static function bundledEdge(network : Network, options : Object):void
		{
			network.data.edges.setProperties({
				lineWidth: options.edge_lineWidth || 2,
				lineColor: options.edge_lineColor || 0xff0055cc,
				mouseEnabled: false//,          // non-interactive edges
				//visible: neq("source.parentNode","target.parentNode")
			});

			network.operators.add(new BundledEdgeRouter(0.95));
			// set the edge alpha values
			// longer edge, lighter alpha: 1/(2*numCtrlPoints)
			
			network.operators.add(new PropertyEncoder({alpha: div(1,"points.length")}, Data.EDGES));	
		}
		
		public static function multiEdge(network : Network, options : Object):void
		{
			network.data.edges.setProperties({
				lineWidth: options.edge_lineWidth || 3,
				lineAlpha: options.edge_lineAlpha || 1,
				arrowType: "TRIANGLE",
				lineColor: 0xff0000bb,
				mouseEnabled: true,
				visible:true,
				renderer: MultiEdgeRenderer.instance
			});

		}

	}
}