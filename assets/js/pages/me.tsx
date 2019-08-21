import * as React from "react"
import { Flex, Spinner, Sans, Separator } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import PlacesWall from "../components/placesWall";
import { useQuery } from "@apollo/react-hooks";

const MY_LIST = gql`
  query Me {
      me{
        name
        lists(first: 10){
          edges{
            node{
              listType
              place {
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
          }
        }
      }
    }
`
export const Me = () => {
  const { loading, data } = useQuery(MY_LIST)
  return (
    <Flex flexDirection="column">
      <Header noLogin={false}/>
      { loading && <Spinner/>}
      { !loading && data &&
        <>
          <Sans size={5}>My List</Sans>
          <Separator width={70}/>
          <PlacesWall places={data.me.lists.edges.map(l => l.node.place)}/>
        </>
      }
    </Flex>
  )
}
