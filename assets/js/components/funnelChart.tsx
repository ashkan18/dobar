import * as React from "react"

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
    const rectStyles = Object.assign({}, STYLE.barStylesBase, {width: `${width}px`})
    const rect = <div style={rectStyles}>{`${d.name}: ${d.value}`}</div>
    let trap
    if(prevWidth) {
      const trapStyles = Object.assign({}, STYLE.trapStylesBase, {
        width: `${width + STYLE.padding * 2}px`,
        borderLeft: `${(prevWidth- width)/2}px solid transparent`,
        borderRight: `${(prevWidth - width)/2}px solid transparent`
      })
      trap = <div style={trapStyles}></div>
   }
   prevWidth = width


    return [trap, rect]
  })

  return <div>{bars}</div>;
}


const STYLE = {
  padding: 0,
  barStylesBase: {
    border: '1px solid #000',
    margin: '0 auto',
    padding: 5
  },

  trapStylesBase: {
    height: 0,
    borderTop: '10px solid #FFE076',
    margin: '0 auto',
  }
}
