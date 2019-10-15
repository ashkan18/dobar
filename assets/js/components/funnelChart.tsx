import * as React from "react"
import { Sans } from "@artsy/palette"

interface FunnelChartData {
  name: string
  value: number
}

interface Props {
  data: Array<FunnelChartData>
  chartWidth: number;
}

export const FunnelChart = ({data, chartWidth} : Props) => {
  const max = data.reduce((all, d) => {
    return d.value > all ? d.value : all
  }, Number.NEGATIVE_INFINITY)
  let prevWidth: number
  const bars = data.map(d => {
    const width = (d.value / max) * chartWidth
    const rectStyles = Object.assign({}, STYLE.barStylesBase, {width: `${chartWidth}px`})
    const rect = <Sans size={1} style={rectStyles}>{`${d.name}: ${d.value}`}</Sans>
    let trap
    if(prevWidth) {
      const trapStyles = Object.assign({}, STYLE.trapStylesBase, {
        width: `${width + STYLE.padding * 2 - 4}px`,
        borderLeft: `${(prevWidth- width) / 2 }px solid transparent`,
        borderRight: `${(prevWidth - width) / 2 }px solid transparent`
      })
      trap = <div style={trapStyles}></div>
   }
   prevWidth = width


    return [trap, rect]
  })

  const chartStyles = Object.assign({}, STYLE.chartStyle, {width: `${chartWidth}px`})
  return <div style={chartStyles}>{bars}</div>;
}


const STYLE = {
  padding: 0,
  chartStyle: {
    border: '1px solid lightgray',
    margin: '0 auto',
    padding: 0
  },
  barStylesBase: {
    margin: '0 auto',
    padding: 5,
    textAlign: 'center'
  },

  trapStylesBase: {
    height: 0,
    borderTop: '20px solid #ffcd74',
    margin: '0 auto',
  }
}
