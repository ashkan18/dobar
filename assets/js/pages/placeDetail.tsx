import * as React from "react"
import { Spinner, Flex, Sans } from "@artsy/palette"

import Header from "../components/header"
import gql from "graphql-tag"
import { useQuery } from "@apollo/react-hooks"
import { Questions } from "../components/questions"

interface Props {
  match: any
}

const FIND_PLACE_QUERY = gql`
  query FindPlace($id: ID!){
    place(id: $id) {
      id
      name
      location
      tags
    }
  }
`

export const PlaceDetail = (props: Props) => {
  const { loading, data } = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  if (loading) {
    return(
      <>
        <Header noLogin={false}/>
        <Spinner size="large"/>
      </>
    )
  } else if (data) {
    return(
      <>
        <Header noLogin={false}/>
        <Flex flexDirection="column" justifyContent="space-between">
          <Sans size={10}>{data.place.name}</Sans>
          <Sans size={6}>{data.place.tags.map(t => `#${t}`).join(" ")}</Sans>
          <Questions place={data.place}/>
        </Flex>
      </>
    )
  }
}
