import * as React from "react"
import { PlaceBrick } from "./placeBrick";
import { Flex, Sans, BorderBox, Separator, Serif, Box } from "@artsy/palette";

export interface Props{
  places: Array<any>
  feature: string
}

export const FeaturedPlaces = (props: Props) => {
  return (
    <Box m={2} flexDirection={"column"}>
      <Sans size={5} weight={"bold"}>{props.feature}</Sans>
      <Separator mb={2}/>
      <Flex flexDirection="row" alignContent="top" justifyContent="space-around">
        {props.places.map(p => <PlaceBrick key={p.id} place={p}/>)}
      </Flex>
    </Box>
  )
}
