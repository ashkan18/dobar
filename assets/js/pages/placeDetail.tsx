import * as React from "react"
import { Spinner, Flex, Sans, Image } from "@artsy/palette"

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
      images {
        urls {
          thumb
          original
        }
      }
    }
  }
`

export const PlaceDetail = (props: Props) => {
  const { loading, data } = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  if (loading) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Spinner size="large"/>
      </Flex>
    )
  } else if (data) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Flex flexDirection="column" justifyContent="space-between" m="auto">
          <Sans size={10}>{data.place.name}</Sans>
          <Image src={data.place.images[0].urls.original}/>
          <Sans size={3}>{data.place.tags.map(t => `#${t}`).join(" ")}</Sans>
          <Questions place={data.place}/>
        </Flex>
      </Flex>
    )
  }
}
