import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:posture_guard/bar%20graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary; //[sunamount,monamount,...]
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {

    //initialize bar data
    BarData myBarData = BarData(
      sunAmount: weeklySummary[0], 
      monAmount: weeklySummary[1], 
      tueAmount: weeklySummary[2], 
      wedAmount: weeklySummary[3], 
      thurAmount:weeklySummary[4], 
      friAmount: weeklySummary[5], 
      satAmount: weeklySummary[6]
      );

      myBarData.initializeBarData();




    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), 
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),   
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles,) )  
          ),
        barGroups: myBarData.barData
        .map((data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: Colors.blue[300],
                width: 25,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(show: true,toY: 100,color: Colors.blue[50],),
                ),
              ],
            ),
          )
        .toList(),
      ),


    );
  }
}


Widget getBottomTitles (double value,TitleMeta meta){
  const Style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('S', style: Style,);    
      break;
    case 1:
      text = const Text('M', style: Style,);    
      break;
    case 2:
      text = const Text('T', style: Style,);    
      break;
    case 3:
      text = const Text('W', style: Style,);    
      break;
    case 4:
      text = const Text('T', style: Style,);    
      break;
    case 5:
      text = const Text('F', style: Style,);    
      break;
    case 6:
      text = const Text('S', style: Style,);    
      break;

    default:
      text = const Text('',style: Style,);
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);



}