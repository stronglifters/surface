var RecoveryDay = React.createClass({
  propTypes: {
    squat: React.PropTypes.number,
    benchPress: React.PropTypes.number,
    overheadPress: React.PropTypes.number
  },

  render: function() {
    return (
      <div>
        <h1 className="title">Wednesday</h1>
        <h2 className="subtitle">Recovery Day</h2>
        <table className="table">
          <tbody>
            <tr>
              <td><strong>Squat</strong> 2x5 @ 80% of Monday's work weight</td>
              <td>{this.rounded(this.rounded(this.props.squat * 0.9) * 0.8)}lbs</td>
            </tr>
            <tr>
              <td><strong>*Bench Press</strong> (3x5 @ 90% 5RM)</td>
              <td>{this.props.bench_press * 0.9}lbs</td>
            </tr>
            <tr>
              <td>*<strong>Overhead Press</strong> 3x5 @ 90% 5RM</td>
              <td>{this.props.overhead_press * 0.9}lbs</td>
            </tr>
            <tr>
              <td><strong>Chin-up</strong> 3 x body weight</td>
              <td></td>
            </tr>
            <tr>
              <td><strong>Back Extension</strong> or <strong>Glute Ham Raise</strong> 5x10</td>
              <td></td>
            </tr>
          </tbody>
        </table>
        <p className="content is-small">*Bench press if you overhead pressed on Monday.</p>
      </div>
    );
  },

  rounded: function(n) {
    return n - (n % 5);
  }
});
