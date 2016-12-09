var Workout = React.createClass({
  render: function(){
    return (
      <div>
        <div className="row">
          <p>Body Weight: {this.props.workout.body_weight.amount}</p>
          <p>Routine: {this.props.workout.routine_name}</p>
        </div>
        <Exercises exercises={this.props.workout.exercises} />
      </div>
    );
  }
});
